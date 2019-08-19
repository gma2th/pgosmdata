.PHONY: help
help: ## print this message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)''

.PHONY: clean-files
clean-files: ## remove data files
	@rm -rf data/*

.PHONY: clean-db
clean-db: ## drop db tables
	@psql ${DATABASE_URL} -f sql/drop_polygon.sql

.PHONY: clean
clean: clean-files clean-db ## clean-files, clean-db

.PHONY: createtable
createtable: clean-db ## clean-db, create sql table
	@psql ${DATABASE_URL} -f sql/create_polygon.sql

.PHONY: download
download: clean-files ## clean-files, download shp files from osmdata
	@wget -P ./data https://osmdata.openstreetmap.de/download/land-polygons-split-4326.zip
	@wget -P ./data https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip
	@unzip ./data/land-polygons-split-4326.zip -d data
	@unzip ./data/water-polygons-split-4326.zip -d data


.PHONY: prepare
prepare: ## convert shp files to sql files
	@shp2pgsql -G -s 4326 -I ./data/land-polygons-split-4326/land_polygons land_polygon public.land_polygon > data/create_land_polygon.sql
	@shp2pgsql -G -s 4326 -I ./data/water-polygons-split-4326/water_polygons water_polygon public.water_polygon > data/create_water_polygon.sql

.PHONY: insert
insert: ## insert data into db
	@psql ${DATABASE_URL} -f data/create_land_polygon.sql
	@psql ${DATABASE_URL} -f data/create_water_polygon.sql
	@psql ${DATABASE_URL} -f sql/insert_polygon.sql

.PHONY: update
update: prepare insert ## prepare, insert

.PHONY: upgrade
upgrade: download update ## download, update

.PHONY: all
all: createtable upgrade ## createtable, upgrade
