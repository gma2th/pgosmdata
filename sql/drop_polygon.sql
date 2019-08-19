drop index if exists osm_polygon_geog_idx ;
drop index if exists osm_polygon_unique_polygon_id ;
drop materialized view if exists osm_polygon ;
drop table if exists osm_polygon_history ;
drop type if exists osm_polygon_type ;
drop table if exists land_polygon;
drop table if exists water_polygon;
