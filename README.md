# PgOSMData

This project load FOSSGIS OSMData land and water polygon to postgres.
It will load the data into the tables land_polygon and water_polygon.
It uses WGS84 projection.
See https://osmdata.openstreetmap.de/

## Requirements

- PostgreSQL
- PostGIS
- shp2pgsql

## Install

```sh
$ createdb pgosmdata
$ export DATABASE_URL="postgresql://localhost/pgosmdata"
$ psql $DATABASE_URL -c "CREATE EXTENSION postgis;
$ make all
```

## Help

```sh
$ make help
help                           print this message
clean-files                    remove data files
clean-db                       drop db tables
clean                          clean-files, clean-db
download                       clean-files, download shp files from osmdata
prepare                        convert shp files to sql files
insert                         insert data into db
update                         prepare, insert
all                            download, update
```
