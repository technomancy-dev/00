#!/bin/bash
set -e

# Restore the database if it does not already exist.
if [ -f  "/app/${DATABASE_PATH}" ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists ${REPLICA_URL}"
	litestream restore -v -if-replica-exists -o "/app/bin/${DATABASE_PATH}" "${REPLICA_URL}"
fi

exec litestream replicate -exec "/app/bin/server" "/app/bin/00.db" "${REPLICA_URL}"
