#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
printf "\n\n\n### APPENDED by postCreateCommand ###\n\n" >> ~/.bashrc
cat ${SCRIPT_DIR}/bashrc_append >> ~/.bashrc

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  bat \
  sqlite3 \
  postgresql-common

# Matching PG CLI for local DB installation
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
  && sudo apt update \
  && sudo apt install -y postgresql-client-17

# Enable working with pyodbc and SQL server
# https://learn.microsoft.com/en-us/sql/connect/python/pyodbc/python-sql-driver-pyodbc
$SCRIPT_DIR/installOdbcDriver.sh
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18


