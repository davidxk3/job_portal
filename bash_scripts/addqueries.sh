#!/bin/bash
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

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
SELECT * FROM JobListing;
SET WRAP OFF
EXIT;
EOF

echo -ne "\n\nWhat is your username (applicant)?\n"
echo -ne "Response: " 
read user 
echo  "What job would you like to apply to? Provide Job ID."
echo -ne "Response: "
read job 
echo "What skills do you have?"
echo -ne "Response: "
read skills 
echo "What work experience do you have?"
echo -ne "Response: "
read workexperience
echo "Your application has been submitted."


echo -ne "Here is the record of your resume and application.\n\n\n"

# Get new resume ID 
resumeid=$(sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SELECT COUNT(*) FROM Resume;
EXIT;
EOF
)
resumeid=$(echo $resumeid | tr -cd '0-9')
resumeid=$((resumeid+1))
echo "Your Resume ID: $resumeid"

# Get new application ID 
applicationid=$(sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SELECT COUNT(*) FROM Application;
EXIT;
EOF
)
applicationid=$(echo $applicationid | tr -cd '0-9')
applicationid=$((applicationid+1))
echo "Your Application ID: $applicationid"

echo "Your application has been successfully finished."
sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SET PAGESIZE 50000
SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET COLSEP '   '

INSERT INTO Resume VALUES($resumeid, '$skills', '$workexperience', '$user');
INSERT INTO APPLICATION VALUES($applicationid, 'Pending', '$user', '$job', '$resumeid');

COLUMN SKILLS FORMAT A40
COLUMN WORKEXPERIENCE FORMAT A40
COLUMN USERNAME FORMAT A20
SELECT * FROM Resume WHERE ResumeID = '$resumeid';

COLUMN STATUS FORMAT A32
COLUMN USERNAME FORMAT A20
COLUMN JOBID FORMAT A20
SELECT * FROM Application WHERE ApplicationID = '$applicationid';
SET WRAP OFF
EXIT;
EOF





