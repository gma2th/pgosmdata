begin;

update
    osm_polygon_history
set
    is_active = false;

insert into osm_polygon_history (geog
    , "type"
    , is_active
    , added_at)
select
    geog
    , 'land'
    , true
    , now()
from
    land_polygon;

insert into osm_polygon_history (geog
    , "type"
    , is_active
    , added_at)
select
    geog
    , 'water'
    , true
    , now()
from
    water_polygon;

commit;

refresh materialized view concurrently osm_polygon;

drop table if exists land_polygon;

drop table if exists water_polygon;
