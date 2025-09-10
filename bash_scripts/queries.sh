#!/bin/bash
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"


sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" >> temp <<EOF
SET LINESIZE 150

-- Query to retrieve any job listings that do not have any applications --
SELECT JobID, JobTitle, JobLocation, Wage
FROM JobListing
MINUS
SELECT JobListing.JobID, JobListing.JobTitle, JobListing.JobLocation, JobListing.Wage
FROM JobListing
JOIN Application ON JobListing.JobID = Application.JobID;


-- Query to retrieve all job seekers that applied for Data Analyst or Software developer positions --
SELECT DISTINCT JobSeeker.FullName, JobSeeker.Username, JobListing.JobTitle
FROM JobSeeker
JOIN Application ON JobSeeker.Username = Application.Username
JOIN JobListing ON Application.JobID = JobListing.JobID
Where JobListing.JobTitle = 'Data Analyst'
UNION
SELECT DISTINCT JobSeeker.FullName, JobSeeker.Username,JobListing.JobTitle
FROM JobSeeker
JOIN Application ON JobSeeker.Username = Application.Username
JOIN JobListing ON Application.JobID = JobListing.JobID
WHERE JobListing.JobTitle = 'Software Developer'; 

-- Query that retrieves all the names of applicants who have applied to any job(s) with a salary greater than \$50,000 --
SELECT DISTINCT JobSeeker.FullName
FROM JobSeeker
WHERE EXISTS (
SELECT *
FROM Application
JOIN JobListing ON Application.JobID = JobListing.JobID
WHERE Application.Username = JobSeeker.Username
AND JobListing.Wage > '\$50000'
);


--Query Find Job Listings with more than 3 applications--
SELECT JobListing.JobTitle, JobListing.JobLocation, COUNT(Application.ApplicationID) AS TotalApplications
FROM JobListing
JOIN Application ON JobListing.JobID = Application.JobID
GROUP BY JobListing.JobTitle, JobListing.JobLocation
HAVING COUNT(Application.ApplicationID) > 3
ORDER BY TotalApplications DESC;


--Query to retrieve job seekers who have applied to more than two jobs--
SELECT JobSeeker.FullName, JobSeeker.Username, COUNT(Application.JobID) AS JobApplications
FROM JobSeeker
JOIN Application ON JobSeeker.Username = Application.Username
GROUP BY JobSeeker.FullName, JobSeeker.Username
HAVING COUNT(Application.JobID) > 2
ORDER BY JobApplications DESC;

exit;
EOF

# Read lines from file
count=1

while read line ; do
	# Everytime we see "^SQL", it's another one of our queries so we can write desc for each one
	if echo $line |  grep -E '^(SQL>)' > /dev/null ; then
		if [ "$count" -eq 1 ] ; then
			echo -e "\n\nQuery #1: Retrieve JobListings that do not have any Applications\n"
		elif [ "$count" -eq 2 ] ; then
			echo -e "\n\nQuery #2: Retrieve all JobSeekers that applied to Data Analyst or Software Developer position\n"
                elif [ "$count" -eq 3 ] ; then
			echo -e "\n\nQuery #3: Retrieve all the names of applicants who have applied to any job(s) with salary greater than '\$50,000'\n"
                elif [ "$count" -eq 4 ] ; then
			echo -e "\n\nQuery #4: Find JobListings with more than 3 applications\n"
                elif [ "$count" -eq 5 ] ; then
			echo -e "\n\nQuery #5: Retrieve JobSeekers who have applied to more than two jobs\n"
		fi
		count=$((count+1))
	# Just print it if it's not ^SQL
	else
		echo "$line"

	fi
done < temp

# Remove temp
rm temp
