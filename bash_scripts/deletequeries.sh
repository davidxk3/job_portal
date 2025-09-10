#!/bin/bash
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

showApps() {
sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SET PAGESIZE 50000
SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET COLSEP '   '

COLUMN USERNAME FORMAT A20
COLUMN FULLNAME FORMAT A30
COLUMN ADDRESS FORMAT A40
COLUMN EDUCATION FORMAT A40
COLUMN PENDINGINTERVIEWS FORMAT A20
SELECT * FROM Application where Username = '$username';
SET WRAP OFF
EXIT;
EOF
}


echo "What is your applicant username?"
echo -ne "Response: "
read username
echo "Listing your applications..."

showApps

echo -ne "\n\n\n"
echo "Which application would you like to delete? (enter application ID)"
echo -ne "Response: "
read application 

sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SET PAGESIZE 50000
SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET COLSEP '   '

COLUMN USERNAME FORMAT A20
COLUMN FULLNAME FORMAT A30
COLUMN ADDRESS FORMAT A40
COLUMN EDUCATION FORMAT A40
COLUMN PENDINGINTERVIEWS FORMAT A20
DELETE FROM Application where ApplicationID = '$application';
SET WRAP OFF
EXIT;
EOF

echo -ne "\n\n\n"
echo "Your application has been successfully deleted."
echo "Your new applications: "

showApps
