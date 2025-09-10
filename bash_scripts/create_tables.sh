#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

# Read into file to grep later to "clean" input
sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" >> temp <<EOF

	    CREATE TABLE JobSeeker (
                Username                            VARCHAR2(16) UNIQUE,
                FullName                            VARCHAR2(32),
                Address                             VARCHAR2(32),
                Education                           VARCHAR2(64),
                PendingInterviews                   VARCHAR2(256)
            );
            
            CREATE TABLE Resume (
                ResumeID                            INTEGER PRIMARY KEY,
                Skills                              VARCHAR2(1024) DEFAULT 'None listed',
                WorkExperience                      VARCHAR2(1024) DEFAULT 'None listed',
                Username                            VARCHAR2(16),
                FOREIGN KEY (Username) REFERENCES JobSeeker(Username) ON DELETE CASCADE
            );
            
            CREATE TABLE UserProfile (
                Username                            VARCHAR2(16) PRIMARY KEY,
                PhoneNumber                         VARCHAR2(12) DEFAULT 'XXX-XXX-XXXX' NOT NULL,
                Password                            VARCHAR2(32),
                FullName                            VARCHAR2(32),
                UserLocation                        VARCHAR2(32)
            );
            
            CREATE TABLE UserInfo (
                Username                            VARCHAR2(16) PRIMARY KEY,
                Password                            VARCHAR2(32) NOT NULL,
                Type                                VARCHAR2(10) NOT NULL
            );
            
            CREATE TABLE Employer (
                RecruiterID                         VARCHAR2(16) UNIQUE,
                FullName                            VARCHAR2(32),
                Company                             VARCHAR2(32) NOT NULL
            );
            
            CREATE TABLE JobListing (
                JobID                               VARCHAR(32) PRIMARY KEY,
                JobTitle                            VARCHAR2(32) NOT NULL,
                RecruiterID                         VARCHAR2(16) NOT NULL REFERENCES Employer(RecruiterID) ON DELETE CASCADE,
                JobDescription                      VARCHAR2(256) NOT NULL,
                JobLocation                         VARCHAR2(32),
                ApplicationDeadline                 VARCHAR2(16) NOT NULL,
                Wage                                VARCHAR2(16) NOT NULL
            );
            
            CREATE TABLE Application (
                ApplicationID                       INTEGER PRIMARY KEY,
                Status                              VARCHAR2(8) NOT NULL,
                Username                            VARCHAR2(16) NOT NULL REFERENCES JobSeeker(Username) ON DELETE CASCADE,
                JobID                               VARCHAR2(32) NOT NULL REFERENCES JobListing(JobID) ON DELETE CASCADE,
                ResumeID                            INTEGER NOT NULL REFERENCES Resume(ResumeID) ON DELETE CASCADE
            );  

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

