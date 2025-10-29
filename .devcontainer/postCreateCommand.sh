#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
printf "\n\n\n### APPENDED by postCreateCommand ###\n\n" >> ~/.bashrc
cat ${SCRIPT_DIR}/bashrc_append >> ~/.bashrc

#https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-python#install-the-azure-functions-core-tools
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
sudo mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs 2>/dev/null | cut -d'.' -f 1)/prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list'

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  bat \
  git-lfs \
  sqlite3 \
  postgresql-common \
  azure-functions-core-tools-4 # work-around for disabled "ghcr.io/jlaundry/devcontainer-features/azure-functions-core-tools:1" feature (see devcontainer.json)

# Matching PG CLI for local DB installation
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
  && sudo apt update \
  && sudo apt install -y postgresql-client-17

# Enable working with pyodbc and SQL server
# https://learn.microsoft.com/en-us/sql/connect/python/pyodbc/python-sql-driver-pyodbc
$SCRIPT_DIR/installOdbcDriver.sh
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18


