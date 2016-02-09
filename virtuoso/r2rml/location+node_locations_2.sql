--
-- RDF View on relational data using R2RML mapping language.
-- As an example, a single table (pp_accession) is exposed from BreeDB.
--
-- Author: Arnold Kuzniar (original BreeDB), Patrick Bos (Hadrianus)
-- 

-- clear graphs
SPARQL CLEAR GRAPH <http://temp/hadrianus>;

-- insert R2RML into a temporary graph

DB.DBA.TTLP('
@prefix rr: <http://www.w3.org/ns/r2rml#> .
@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> .
@prefix dwc: <http://rs.tdwg.org/dwc/terms/> .
@prefix dct: <http://purl.org/dc/terms/> .
@prefix gn: <http://www.geonames.org/ontology#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix hadr: <http://hadrianus.it/> .
@prefix lod: <http://hadrianus.it/lod/> .
@prefix graph: <http://hadrianus.it/lod/graph/> .
@prefix class: <http://hadrianus.it/lod/class/> .

<#TriplesMapMapLocations>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:tableSchema "Hadrianus";
      rr:tableOwner  "hadrianus";
      rr:tableName   "location";
    ];
    -- Note: official specification says it should be:
    -- rr:tableName "Hadrianus.hadrianus.location";
    -- but Virtuoso only seems to support the above, unofficial syntax.

    rr:subjectMap [
      rr:template "http://hadrianus.it/map/location/{lid}";
      rr:class geo:Point;
      rr:graph graph:map_locations;
      rr:termType rr:IRI
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

<#TriplesMapLocatie>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:sqlQuery """
        SELECT n.nid AS nid, n."language" AS "language", n.title AS title, li.lid AS lid
        FROM Hadrianus.hadrianus.node AS n, Hadrianus.hadrianus.location_instance AS li
        WHERE n.type = \'locatie\' AND n.nid = li.nid
      """;
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph graph:locatie;
      rr:termType rr:IRI;
      rr:class geo:SpatialThing;
    ];

    rr:predicateObjectMap [
      rr:predicate rdfs:label;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column "title";
      ];
    ];
    -- It seems to be impossible currently to use a column for the rr:language
    -- property in the objectMap. In one of the working documents a
    -- rr:propertyColumn tag is defined which might be useful, but that is not
    -- in the official standard.

    rr:predicateObjectMap [
      rr:predicate geo:location;
      rr:objectMap [
        rr:parentTriplesMap hadr:TriplesMapMapLocations;
        rr:joinCondition [
            rr:child "lid";
            rr:parent "lid";
        ];
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
