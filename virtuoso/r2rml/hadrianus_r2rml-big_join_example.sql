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
@prefix erl: <http://erlangen-crm.org/current/> .
@prefix vra: <http://www.vraweb.org/vracore/vracore3#> .

<#TriplesMapMapLocations>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:tableSchema "Hadrianus";
      rr:tableOwner  "hadrianus";
      rr:tableName   "location";
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/lod/geo_location/{lid}";
      rr:class    geo:Point;
      rr:graph    graph:geo_locations;
      rr:termType rr:IRI
    ];

    rr:predicateObjectMap [
      rr:predicate geo:lat;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "latitude";
        rr:datatype xsd:decimal
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate geo:long;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "longitude";
        rr:datatype xsd:decimal
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate gn:countryCode;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "country"
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
      rr:graph    graph:locatie;
      rr:termType rr:IRI;
      rr:class    geo:SpatialThing;
    ];

    rr:predicateObjectMap [
      rr:predicate erl:P1_is_identified_by;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "title";
        rr:class    erl:E41_Appellation;
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate geo:location;
      rr:objectMap [
        rr:parentTriplesMap <#TriplesMapMapLocations>;
        rr:joinCondition [
            rr:child  "lid";
            rr:parent "lid";
        ];
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate lod:onMap;
      rr:objectMap [
        rr:template "http://hadrianus.it/map/location/{nid}";
        rr:termType rr:IRI;
      ];
    ];
.

<#TriplesMapAddress>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:sqlQuery """
        SELECT n.nid AS nid, n."language" AS "language", n.title AS title, li.lid AS lid
        FROM Hadrianus.hadrianus.node AS n, Hadrianus.hadrianus.location_instance AS li
        WHERE n.type = \'address\' AND n.nid = li.nid
      """;
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph    graph:address;
      rr:termType rr:IRI;
      rr:class    erl:E45_Address;
    ];

    rr:predicateObjectMap [
      rr:predicate erl:P1_is_identified_by;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "title";
        rr:class    erl:E41_Appellation;
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate geo:location;
      rr:objectMap [
        rr:parentTriplesMap <#TriplesMapMapLocations>;
        rr:joinCondition [
            rr:child  "lid";
            rr:parent "lid";
        ];
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate lod:onMap;
      rr:objectMap [
        rr:template "http://hadrianus.it/map/address/{nid}";
        rr:termType rr:IRI;
      ];
    ];
.

<#TriplesMapObject>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:sqlQuery """
        SELECT n.nid AS nid, n.title AS title,
               f_al.entity_id AS al_nid,
               f_l.entity_id AS l_nid,
               f_lws.entity_id AS lws_nid,
               f_lws.delta AS lws_delta,
               f_p.entity_id AS p_nid
        FROM Hadrianus.hadrianus.node AS n,
             Hadrianus.hadrianus.field_data_field_actual_location as f_al,
             Hadrianus.hadrianus.field_data_field_location as f_l,
             Hadrianus.hadrianus.field_data_field_location_of_work_shown as f_lws,
             Hadrianus.hadrianus.field_data_field_person as f_p
        WHERE     n.type = \'object\'
              AND n.nid  = f_al.entity_id
              AND n.nid  = f_l.entity_id
              AND n.nid  = f_lws.entity_id
              AND n.nid  = f_p.entity_id
      """;
    ];

    -- TODO: redo above join: make separate TriplesMap for every join!

    -- erl:P53_has_former_or_current_location, erl:P54_has_current_permanent_location or erl:P55_has_current_location (al)?
    -- I will assume that the actual_location is in fact a permanent exposition,
    -- so then we will use P54 for that.
    
    -- erl:P62_depicts (lws)

    -- Looking at the database, it seems like the field_location is a sort of
    -- merger of depicted location in case of images and location-node in case
    -- an object node (e.g. Piazza Navona, node 15) is also a location node (71).
    -- Unfortunately, most location is data is in this table. The lws table only
    -- has 8 entries.
    
    -- vra:creator (p)
    
    -- Hebben alle nodes wel van alle typen locatie een veld? Of maar van 1?

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph    graph:object;
      rr:termType rr:IRI;
      rr:class    erl:E22_Man-Made_Object;
    ];

    rr:predicateObjectMap [
      rr:predicate erl:P1_is_identified_by;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "title";
        rr:class    erl:E41_Appellation;
      ];
    ];

    rr:predicateObjectMap [
      rr:predicate lod:onMap;
      rr:objectMap [
        rr:template "http://hadrianus.it/map/work/{nid}";
        rr:termType rr:IRI;
      ];
    ];
.

<#TriplesMapPerson>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:sqlQuery """
        SELECT n.nid AS nid, n."language" AS "language", n.title AS title
        FROM Hadrianus.hadrianus.node AS n
        WHERE n.type = \'person\'
      """;
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph    graph:person;
      rr:termType rr:IRI;
      rr:class    erl:E21_Person;
    ];

    rr:predicateObjectMap [
      rr:predicate erl:P1_is_identified_by;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "title";
        rr:class    erl:E41_Appellation;
      ];
    ];
.

<#TriplesMapGroup>
    a rr:TriplesMap;

    rr:logicalTable [
      rr:sqlQuery """
        SELECT n.nid AS nid, n."language" AS "language", n.title AS title
        FROM Hadrianus.hadrianus.node AS n
        WHERE n.type = \'group\'
      """;
    ];

    rr:subjectMap [
      rr:template "http://hadrianus.it/node/{nid}";
      rr:graph    graph:group;
      rr:termType rr:IRI;
      rr:class    erl:E74_Group;
    ];

    rr:predicateObjectMap [
      rr:predicate erl:P1_is_identified_by;
      rr:objectMap [
        rr:termType rr:Literal;
        rr:column   "title";
        rr:class    erl:E41_Appellation;
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
