# PgOSMData

This project load FOSSGIS OSMData land and water polygon to postgres.
It use WGS84 projection and splited large polygon.
See https://osmdata.openstreetmap.de/

It performs the following steps:

- load OSMData to `land_polygon` and `water_polygon` table
- insert `land_polygon` and `water_polygon` data to `osm_polygon_history`
- refresh the `osm_polygon` materialized view wich contains only the last inserted polygon
- delete `land_polygon` and `water_polygon` tables


# Requirements

- PostgreSQL
- PostGIS
- shp2pgsql


# Install

```
$ createdb osm_polygon
$ export DATABASE_URL="postgresql://localhost/osm_polygon"
$ psql $DATABASE_URL -c "CREATE EXTENSION postgis;
$ psql $DATABASE_URL -c "CREATE EXTENSION postgis_topology;"
$ make all
```

# Help

```
$ make help
help                           print this message
clean-files                    remove data files
clean-db                       drop db tables
clean                          clean-files, clean-db
createtable                    clean-db, create sql table
download                       clean-files, download shp files from osmdata
prepare                        convert shp files to sql files
insert                         insert data into db
update                         prepare, insert
upgrade                        download, update
all                            createtable, upgrade
```
