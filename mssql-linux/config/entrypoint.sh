#!/bin/bash

# Start SQL Server
/opt/mssql/bin/sqlservr &

# Start the script to setup the instance
/usr/config/setup.sh

# Call extra command
eval $1