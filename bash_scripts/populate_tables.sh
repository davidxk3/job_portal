#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

. "./creds"

sqlplus64 "${USERNAME}/${PASSWORD}@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" >> temp <<EOF

SET DEFINE OFF
-- 1. Insert data into UserInfo table
INSERT INTO UserInfo(Username, Password, Type)
VALUES('recruiter', 'recruiter123', 'recruiter');

INSERT INTO UserInfo(Username, Password, Type)
VALUES('recruiter2', 'recruiter123', 'recruiter');

INSERT INTO UserInfo(Username, Password, Type)
VALUES('recruiter3', 'recruiter123', 'recruiter');

INSERT INTO UserInfo(Username, Password, Type)
VALUES('recruiter4', 'recruiter123', 'recruiter');


INSERT INTO UserInfo(Username, Password, Type)
VALUES('applicant', 'applicant123', 'applicant');

INSERT INTO UserInfo(Username, Password, Type)
VALUES('dyliu', 'david*', 'applicant');

-- 2. Insert data into JobSeeker table
INSERT INTO JobSeeker(Username, FullName, Address, Education, PendingInterviews)
VALUES('applicant', 'John Doe', '1234 Elm Street, California, USA', 'Bachelors in Computer Science', 'None');

INSERT INTO JobSeeker(Username, FullName, Address, Education, PendingInterviews)
VALUES('dyliu', 'David Liu', '123 TMU Street, Toronto, ON', 'Bachelors in Math', 'None');

-- 3. Insert data into Resume table (applicant's resume)
INSERT INTO Resume(ResumeID, Skills, WorkExperience, Username)
VALUES(1, 'Java, SQL, Python', 'Software Engineer at XYZ Corp for 3 years', 'applicant');

INSERT INTO Resume(ResumeID, Skills, WorkExperience, Username)
VALUES(2, 'C, C++, HTML/CSS', '3rd year student in TMU', 'dyliu');

-- 4. Insert data into UserProfile table
INSERT INTO UserProfile(Username, PhoneNumber, Password, FullName, UserLocation)
VALUES('recruiter', '555-123-4567', 'recruiter123', 'Jane Recruiter', 'San Francisco');

INSERT INTO UserProfile(Username, PhoneNumber, Password, FullName, UserLocation)
VALUES('applicant', '555-987-6543', 'applicant123', 'John Doe', 'New York');

-- 5. Insert data into Employer table
INSERT INTO Employer(RecruiterID, FullName, Company)
VALUES('recruiter', 'John Doe', 'Tech Solutions');

INSERT INTO Employer(RecruiterID, FullName, Company)
VALUES('recruiter2', 'Trish Vone', 'TechLabs');

INSERT INTO Employer(RecruiterID, FullName, Company)
VALUES('recruiter3', 'Edgar Mack', 'Doordash Inc');

INSERT INTO Employer(RecruiterID, FullName, Company)
VALUES('recruiter4', 'David Liu', 'Google');


-- 6. Insert data into JobListing table
INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software1', 'Software Developer', 'recruiter', 'Develop and maintain software applications.', 'San Francisco', '2024-12-01', '100000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('business2', 'Data Analyst', 'recruiter2', 'Analyze data and build models', 'San Francisco', '2024-12-31', '95000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software3', 'Product Manager', 'recruiter2', 'Manage product lifecycle and roadmap', 'New York', '2024-12-15', '105000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('design4', 'UX Designer', 'recruiter', 'Design user interfaces and experiences', 'Los Angeles', '2025-01-15', '85000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('business10', 'Data Analyst', 'recruiter3', 'Analyze business data to improve company operations and strategies.', 'Chicago', '2025-05-01', '90000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('astrology11', 'Astrologer', 'recruiter3', 'Interpret astrological charts and provide guidance based on celestial positions.', 'Los Angeles', '2025-06-01', '75000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('business12', 'Marketing Manager', 'recruiter4', 'Lead and strategize marketing campaigns to boost brand presence and sales.', 'New York', '2025-07-01', '95000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('physiology13', 'Physiologist', 'recruiter', 'Study human physiology and provide consultations on health and wellness.', 'San Francisco', '2025-08-01', '85000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('astrology14', 'Astrology Consultant', 'recruiter3', 'Advise clients on life decisions based on astrological insights and charts.', 'Miami', '2025-09-01', '80000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software4', 'Software Engineer', 'recruiter', 'Design, develop, and test software applications and systems.', 'Austin', '2024-12-10', '110000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software5', 'Senior Software Developer', 'recruiter2', 'Develop complex software solutions, mentor junior developers, and review code.', 'Seattle', '2024-12-25', '120000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software6', 'Software Architect', 'recruiter3', 'Lead the design and architecture of software systems for enterprise clients.', 'San Francisco', '2025-01-05', '130000');

INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)
VALUES('software7', 'Software Development Manager', 'recruiter4', 'Oversee the software development team and manage product development processes.', 'Chicago', '2025-02-01', '125000');


-- 7. Insert data into Application table
INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(1, 'Pending', 'applicant', 'software1', 1);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(2, 'Pending', 'applicant', 'business2', 1);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(3, 'Pending', 'applicant', 'software3', 1);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(4, 'Pending', 'dyliu', 'software3', 2);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(5, 'Pending', 'applicant', 'design4', 1);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(6, 'Pending', 'applicant', 'design4', 2);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(7, 'Pending', 'applicant', 'design4', 2);

INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID)
VALUES(8, 'Pending', 'applicant', 'design4', 2);


exit;
EOF

# Grep to look for successful creation (1 row created), errors (ORA), and the populate query inserted
grep -E '^(1 row|ORA|SQL>)' temp

# Remove temp
rm temp
