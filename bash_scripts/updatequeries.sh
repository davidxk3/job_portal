#!/bin/bash
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

echo -ne "What is your username (applicant)?\n"
echo -ne "Response: " 
read user 

sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SET PAGESIZE 50000
SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET COLSEP '   '

SELECT * FROM Application WHERE Username = '$user';
SET WRAP OFF
EXIT;
EOF



echo  -ne "\n\nList the application you would like to edit\n"
echo -ne "Response: "
read applicationID 
echo "Changes to the skills you have"
echo -ne "Response: "
read skills 
echo "Changes to the work experience you have"
echo -ne "Response: "
read workexperience
echo "Your application has been updated with the following changes."


echo -ne "Here is the updated record of your resume and application.\n\n\n"

# Get Resume ID
resumeid=$(sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SELECT ResumeID FROM Application WHERE ApplicationID = '$applicationID';
EXIT;
EOF
)
resumeid=$(echo $resumeid | awk '{print $NF}')

echo "Your Resume ID: $resumeid"
echo "Your Application ID: $applicationID"

echo "Your application has been successfully finished."
sqlplus64 -S "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" << EOF
SET PAGESIZE 50000
SET LINESIZE 200
SET WRAP OFF
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON
SET COLSEP '   '

UPDATE Resume SET Skills='$skills', WorkExperience='$workexperience' WHERE ResumeID='$resumeid';

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





