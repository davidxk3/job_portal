#!/bin/bash
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

echo "What records would you like to read?"
echo "JobSeeker, Resume, UserProfile, Employer, JobListing, Application"
read record 

if [[ "$record" != "JobSeeker" ]] && [[ "$record" != "Resume" ]] && [[ "$record" != "UserProfile" ]] && \
   [[ "$record" != "Employer" ]] && [[ "$record" != "JobListing" ]] && [[ "$record" != "Application" ]]; then
    	echo "Invalid input."
else
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
SELECT * FROM $record;
SET WRAP OFF
EXIT;
EOF
fi

