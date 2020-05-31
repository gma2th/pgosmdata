.PHONY: help
help: ## print this message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)''

.PHONY: clean-files
clean-files: ## remove data files
	@rm -rf data/*

.PHONY: clean-db
clean-db: ## drop db tables
	@psql ${DATABASE_URL} -f sql/drop_tables.sql

.PHONY: clean
clean: clean-files clean-db ## clean-files, clean-db

.PHONY: download
download: clean-files ## clean-files, download shp files from osmdata
	@wget -P ./data https://osmdata.openstreetmap.de/download/land-polygons-split-4326.zip
	@wget -P ./data https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip
	@unzip ./data/land-polygons-split-4326.zip -d data
	@unzip ./data/water-polygons-split-4326.zip -d data

.PHONY: prepare
prepare: ## convert shp files to sql files
	@shp2pgsql -s 4326 -I ./data/land-polygons-split-4326/land_polygons land_polygon public.land_polygon > data/create_land_polygon.sql
	@shp2pgsql -s 4326 -I ./data/water-polygons-split-4326/water_polygons water_polygon public.water_polygon > data/create_water_polygon.sql

.PHONY: insert
insert: ## insert data into db
	@psql "${DATABASE_URL}" -c "create extension if not exists postgis"
	@psql "${DATABASE_URL}" -f data/create_land_polygon.sql
	@psql "${DATABASE_URL}" -f data/create_water_polygon.sql

.PHONY: update
update: prepare insert ## prepare, insert

.PHONY: all
all: download update ## download, update
