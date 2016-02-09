--
-- RDF View on relational data using R2RML mapping language.
-- As an example, a single table (pp_accession) is exposed from BreeDB.
--
-- Author: Arnold Kuzniar (original BreeDB), Patrick Bos (Hadrianus)
--

-- clear graphs
SPARQL CLEAR GRAPH <http://temp/hadrianus>;
-- SPARQL CLEAR GRAPH <http://www.eu-sol.wur.nl/passport>;

-- insert R2RML into a temporary graph

-- EGP:
-- subjectMaps have:
-- - either
--   * column or
--   * template (e.g. "IRI#{column}")
-- - class
-- - graph
-- - termtype
--   * IRI or
--   * Literal
-- - datatype if Literal
-- Usually will be template -> IRI and IRI type
--
-- predicateObjectMaps have:
-- - predicate (IRI or prefix:predicate)
-- - objectMap
-- objectMaps in turn have:
-- - either
--   * column or
--   * template (e.g. "IRI#{column}")
-- - termtype
--   * IRI or
--   * Literal
-- - datatype if Literal

DB.DBA.TTLP('
@prefix rr: <http://www.w3.org/ns/r2rml#> .
@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> .
@prefix dwc: <http://rs.tdwg.org/dwc/terms/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix gn: <http://www.geonames.org/ontology#> .

<#TriplesMap1>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:tableSchema "Hadrianus";
      rr:tableOwner  "hadrianus";
      rr:tableName   "location";
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/map/location/{lid}";
      rr:class geo:SpatialThing;
      rr:graph <http://hadrianus.it/locations>;
      rr:termType rr:IRI
    ];

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
