#!/bin/bash

# Wait for MSSQL server to start
export STATUS=1
i=0

while [[ $STATUS -ne 0 ]] && [[ $i -lt 30 ]]; do
	i=$i+1
	/opt/mssql-tools/bin/sqlcmd -t 1 -U sa -P $SA_PASSWORD -Q "select 1" >> /dev/null
	STATUS=$?
done

if [ $STATUS -ne 0 ]; then 
	echo "Error: MSSQL SERVER took more than thirty seconds to start up."
	exit 1
fi

echo "======= MSSQL SERVER STARTED ========" | tee -a ./config.log
# Run the setup script to create the user as sysadmin
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i setup-db.sql

echo "======= MSSQL CONFIG COMPLETE =======" | tee -a ./config.log

if [ $RESTORE_SAMPLE = Y ]; then 
	echo "======= RESTORING SAMPLE DATABASE ========" | tee -a ./config.log
	# Download the sample database backup
	curl -fSL https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak -o /usr/config/AdventureWorks2017.bak
	# Restore the database backup
	/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i restore.sql

	echo "======= COMPLETED RESTORE SAMPLE DATABASE ========" | tee -a ./config.log
fi
