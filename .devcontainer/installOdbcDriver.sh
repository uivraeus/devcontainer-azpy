#!/usr/bin/env bash

# Started with "official guide"
# 👉 https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16&tabs=debian18-install%2Calpine17-install%2Cdebian8-install%2Credhat7-13-install%2Crhel7-offline#tabpanel_1_debian18-install
#
# The stripped away some parts as:
# - Not interested in "optional" parts
#
# Confirm successful install:
#
# ```console
# $ odbcinst -q -d -n
# [ODBC Driver 18 for SQL Server]
# ``` 

set -euxo pipefail

if ! [[ "11 12" == *"$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1)"* ]];
then
    echo "Debian $(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1) is not currently supported.";
    exit 1;
fi

# # Download the package to configure the Microsoft repo
curl -sSL -O https://packages.microsoft.com/config/debian/$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2 | cut -d '.' -f 1)/packages-microsoft-prod.deb
# Install the package
sudo dpkg -i packages-microsoft-prod.deb
# Delete the file
rm packages-microsoft-prod.deb

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
# # optional: for bcp and sqlcmd
# sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
# echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
# source ~/.bashrc
# # optional: for unixODBC development headers
# sudo apt-get install -y unixodbc-dev
# # optional: kerberos library for debian-slim distributions
# sudo apt-get install -y libgssapi-krb5-2
