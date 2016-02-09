--
-- RDF View on relational data using R2RML mapping language.
-- As an example, a single table (pp_accession) is exposed from BreeDB.
--
-- Author: Arnold Kuzniar (original BreeDB), Patrick Bos (Hadrianus)
--
-- THIS FILE IS USED AS A SORT OF NOTEPAD / TEMPLATE FOR THE DIFFERENT NODE
-- CONTENT TYPES. IT IS NOT MEANT TO ACTUALLY RUN!

-- clear graphs
SPARQL CLEAR GRAPH <http://temp/hadrianus>;

-- insert R2RML into a temporary graph

DB.DBA.TTLP('
@prefix rr: <http://www.w3.org/ns/r2rml#> .
@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> .
@prefix dwc: <http://rs.tdwg.org/dwc/terms/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix gn: <http://www.geonames.org/ontology#> .
@prefix hadr: <http://hadrianus.it/> .

<#TriplesMap1>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:tableSchema "Hadrianus";
      rr:tableOwner  "hadrianus";
      rr:tableName   "node";
      -- Based on https://lists.w3.org/Archives/Public/public-rdb2rdf-wg/2011Jun/0175.html
      -- should we just use rr:tableName "Hadrianus.hadrianus.node"?
      -- I think we should. See https://www.w3.org/TR/r2rml/#physical-tables. It
      -- does not mention tableSchema or Owner at all.
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph <http://hadrianus.it/>;
      rr:termType rr:IRI
    ];

    -- no rr:class, this instead:
    rr:predicateObjectMap [
      rr:predicate rdf:type;
      rr:template "http://hadrianus.it/{type}";
      rr:termType rr:IRI;
    ];
    -- TODO:
    -- Make this into some function that based on the type makes a link to some
    -- existing ontology; foaf for person, something like cidoc for object, etc

    rr:predicateObjectMap [
      rr:predicate gterm:germplasmID;
      rr:objectMap [
        rr:template "http://www.eu-sol.wur.nl/passport/SelectAccessionByAccessionID.do?accessionID={accessionID}";
        rr:termType rr:IRI
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate geo:lat;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column "latitude";
        rr:datatype xsd:decimal
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate geo:long;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column "longitude";
        rr:datatype xsd:decimal
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate gn:countryCode;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column "country"
      ];
    ];
.
', 'http://temp/hadrianus', 'http://temp/hadrianus')
;

-- sanity checks
SELECT DB.DBA.R2RML_TEST('http://temp/hadrianus');
DB.DBA.OVL_VALIDATE ('http://temp/hadrianus', 'http://www.w3.org/ns/r2rml#OVL');

-- convert R2RML into Virtuoso's own Linked Data Views script
EXEC('SPARQL ' || DB.DBA.R2RML_MAKE_QM_FROM_G('http://temp/hadrianus'));
