#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

# Read into file to grep later to "clean" input
sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" >> temp <<EOF

DROP TABLE JobSeeker CASCADE CONSTRAINTS;
DROP TABLE Resume CASCADE CONSTRAINTS;
DROP TABLE UserProfile CASCADE CONSTRAINTS;
DROP TABLE UserInfo CASCADE CONSTRAINTS;
DROP TABLE Employer CASCADE CONSTRAINTS;
DROP TABLE JobListing CASCADE CONSTRAINTS;
DROP TABLE Application CASCADE CONSTRAINTS;
exit;
EOF


# Grep - look for lines that begin with "ORA" (error) or "Table" (successfully dropped)
# Count variable to keep track of different entities, ex. JobSeeker = 0, Resume = 1, ...
count=1

# Read lines from file 
while read line ; do
	# Redirect to /dev/null to prevent printing out 
	if echo $line | grep -E '^(Table|ORA)' > /dev/null ; then
		if [ "$count" -eq 1 ] ; then
			echo "JobSeeker: $line"
		elif [ "$count" -eq 2 ] ; then
			echo "Resume: $line"
                elif [ "$count" -eq 3 ] ; then
			echo "UserProfile: $line"
		elif [ "$count" -eq 4 ] ; then
			echo "UserInfo: $line"
                elif [ "$count" -eq 5 ] ; then
			echo "Employer: $line"
                elif [ "$count" -eq 6 ] ; then
			echo "JobListing: $line"
		elif [ "$count" -eq 7 ] ; then
			echo "Application: $line"
		fi
		count=$((count+1))
	fi
done < temp 


# Remove temp file 
rm temp
