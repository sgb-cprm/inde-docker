#!/bin/bash
set -e

function create_user_and_database() {
	local db=$1
	local user=$2
	local pwd=$3

	echo "  Creating user and database '$db'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
		CREATE USER $user WITH ENCRYPTED PASSWORD '$pwd';
		CREATE DATABASE $db OWNER $user TEMPLATE template_postgis;
		GRANT ALL ON geometry_columns TO PUBLIC;
		GRANT ALL ON spatial_ref_sys TO PUBLIC;
EOSQL
}

if [ -n "$GEOSERVER_DATABASE" ]; then
	echo "Geoserver database creation requested: $GEOSERVER_DATABASE"
	create_user_and_database $GEOSERVER_DATABASE $GEOSERVER_USER $GEOSERVER_PASSWORD
	echo "Geoserver database created"
fi

if [ -n "$GEONETWORK_DATABASE" ]; then
	echo "Geonetwork geodatabase creation requested: $GEONETWORK_DATABASE"
	create_user_and_database $GEONETWORK_DATABASE $GEONETWORK_USER $GEONETWORK_PASSWORD
	echo "Geonetwork geodatabase created"
fi
