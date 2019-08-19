create type osm_polygon_type as enum ( 'land'
    , 'water'
);

create table osm_polygon_history (
    id serial
    , geog geography (multipolygon
        , 4326)
    , "type" osm_polygon_type
    , is_active boolean
    , added_at timestamp
);

create materialized view osm_polygon as
select
    id
    , geog
    , "type"
from
    osm_polygon_history
where
    is_active is true;

create unique index osm_polygon_unique_polygon_id on osm_polygon(id);

create index osm_polygon_geog_idx on osm_polygon using gist (geog) ;

GRANT ALL PRIVILEGES ON osm_polygon TO writer ;
GRANT ALL PRIVILEGES ON osm_polygon_history TO writer ;
