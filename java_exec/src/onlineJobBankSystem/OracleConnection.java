/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package onlineJobBankSystem;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.PreparedStatement; 
import java.util.ArrayList;

/**
 *
 * @author David
 */
public class OracleConnection {
    // Constructor 
    String dbURL;
    Connection conn1;
    public OracleConnection() {
        try {
            dbURL = "jdbc:oracle:thin:dyliu/08224738@oracle.scs.ryerson.ca:1521:orcl";
            conn1 = DriverManager.getConnection(dbURL);
        } catch (SQLException e) {
            // Print error message if we can't connect
            System.out.println("Connection failed.");
        }
        
    }
    
    // Returns string fill of user profile info/"incomplete" (not filled out user profile)/or "error" (SQL exception)
    public String getUserProfile(String user) {
        try {
            String getInfo = "SELECT PhoneNumber, FullName, UserLocation FROM UserProfile WHERE Username=?";
            PreparedStatement statement = conn1.prepareStatement(getInfo);
            statement.setString(1, user);
            
            // execute query and get result 
            ResultSet result = statement.executeQuery();
            String output = "";
            // If it was successful
            if (result.next()) {
                output += "Username: " + user + "\n\n"
                        + "Full Name: " + result.getString("FullName") + "\n\n"
                        + "Phone Number: " + result.getString("PhoneNumber") + "\n\n"
                        + "User location: " + result.getString("UserLocation");
            } else {
                return "Fill out your user profile and try again";
            }
            return output;
        } catch (SQLException e) {
            return "Error retrieving user information, try again later.";
        }
    }
    
    // DROP TABLES
    public String runSQLCode(String code) {
        try {
            StringBuilder output = new StringBuilder();
            
            Statement statement = conn1.createStatement();
            for (String sqlCode : code.split(";")) {
                sqlCode = sqlCode.trim();
                try {
                    // Should display information about the query's output 
                    if (sqlCode.contains("SELECT")) {    
                        ResultSet result = statement.executeQuery(sqlCode);
                        if (result.next()) {
                            do {
                                int cols = result.getMetaData().getColumnCount();
                                // print out query 
                                output.append(sqlCode).append("\n\n");
                                output.append("SUCCESS: ");
                                for (int i = 1; i <= cols; i++) {
                                output.append(result.getString(i)).append(" ");
                                }
                                output.append("\n\n\n");
                            } while (result.next());
                        }
                    // Should display information about the rows 
                    } else if (sqlCode.contains("INSERT")) {
                        int rows = statement.executeUpdate(sqlCode);
                        output.append("Rows inserted: ").append(rows).append("\n");
                    // check if successful, if it is just print that the table was successfully dropped 
                    } else if (sqlCode.contains("DROP")) {
                        statement.executeQuery(sqlCode);
                        output.append("Table dropped.\n");
                    // check if successful, if it is just print that the table was successfully dropped
                    } else if (sqlCode.contains("CREATE")) {
                        statement.executeQuery(sqlCode);
                        output.append("Table created.\n");
                    }
                } catch (SQLException e) {
                    output.append("ERROR: ").append(e.getMessage()).append("\n");
                }
            }
            return output.toString();
        } catch (SQLException e) {
            return "Error dropping tables.";
        }
    }
    
    // Get all information needed for a job 
    public String getJobInfo(String jobID) {
        try {
            String getInfo = "SELECT JobID, JobTitle, JobDescription, JobLocation, ApplicationDeadline, Wage FROM JobListing WHERE JobID=?";
            PreparedStatement statement = conn1.prepareStatement(getInfo);
            statement.setString(1, jobID);
            ResultSet result = statement.executeQuery();
            
            String output = "";
            // If it was successful
            if (result.next()) {
                output += "Job ID: " + result.getString("JobID") + "\n"
                        + "Job Title: " + result.getString("JobTitle") + "\n"
                        + "Job Description: " + result.getString("JobDescription") + "\n"
                        + "Location: " + result.getString("JobLocation") + "\n"
                        + "Application Deadline: " + result.getString("ApplicationDeadline") + "\n"
                        + "Wage: " + result.getString("Wage");
            }
            return output;
        } catch (SQLException e) {
            return "Error: try getting job information again later.";
        }
        
    }
    
    // add new job 
    public boolean addNewJob(String category, String user, String name, String location, String wage, String company, String desc, String deadline) {
        try {
            // Get number of jobs currently on the board and add 1 to its category to assign it a JobID
            String amount = "SELECT COUNT(*) FROM JobListing";
            PreparedStatement statement1 = conn1.prepareStatement(amount);
            ResultSet result1 = statement1.executeQuery();
            result1.next();
            int newNum = result1.getInt(1) + 1;
            // New job ID
            String jobID = category + newNum;
            
            String createJob = "INSERT INTO JobListing(JobID, JobTitle, RecruiterID, JobDescription, JobLocation, ApplicationDeadline, Wage)"
                                + " Values(?,?,?,?,?,?,?)";
            PreparedStatement statement2 = conn1.prepareStatement(createJob);
            statement2.setString(1, jobID);
            statement2.setString(2, name);
            statement2.setString(3, user);
            statement2.setString(4, desc);
            statement2.setString(5, location);
            statement2.setString(6, deadline);
            statement2.setString(7, wage);
            int rows = statement2.executeUpdate();   
            
            return rows > 0;
           
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // create new application for job 
    public boolean submitApplication(String user, String skills, String workExperience, String jobID) {
        try {
            // CREATING RESUME 
            // Get resume ID based off # of elements + 1
            String amount = "SELECT COUNT(*) FROM Resume";
            PreparedStatement statement1 = conn1.prepareStatement(amount);
            ResultSet result1 = statement1.executeQuery();
            result1.next();
            int resumeID = result1.getInt(1) + 1;
            
            String createResume = "INSERT INTO Resume(ResumeID, Skills, WorkExperience, Username) Values(?,?,?,?)";
            PreparedStatement statement2 = conn1.prepareStatement(createResume);
            statement2.setInt(1, resumeID);
            statement2.setString(2, skills);
            statement2.setString(3, workExperience);
            statement2.setString(4, user);
            statement2.executeQuery();
            
            // CREATING APPLICATION
            // Get application ID based off # of elements + 1
            String amount2 = "SELECT COUNT(*) FROM Application";
            PreparedStatement statement3 = conn1.prepareStatement(amount2);
            ResultSet result2 = statement3.executeQuery();
            result2.next();
            int applicationID = result2.getInt(1) + 1;
            
            String createApplication = "INSERT INTO Application(ApplicationID, Status, Username, JobID, ResumeID) Values(?,?,?,?,?)";
            PreparedStatement statement4 = conn1.prepareStatement(createApplication);
            statement4.setInt(1, applicationID);
            statement4.setString(2, "Pending");
            statement4.setString(3, user);
            statement4.setString(4, jobID);
            statement4.setInt(5, resumeID);
            statement4.executeQuery();
            return true; 
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }   
    }
    
    // get all jobs
    public ArrayList<String> getJobs() {
        ArrayList<String> jobs = new ArrayList<>();
        String query = "SELECT JobID, JobTitle, RecruiterID, JobLocation, Wage FROM JobListing";
        try {
            PreparedStatement statement = conn1.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                String getCompany = "SELECT Company FROM Employer where RecruiterID=?";
                PreparedStatement statement2 = conn1.prepareStatement(getCompany);
                statement2.setString(1, resultSet.getString("RecruiterID"));
                ResultSet resultSet2 = statement2.executeQuery();
                resultSet2.next();
                String company = resultSet2.getString("Company");
                
                String currentJob = resultSet.getString("JobID") + ": " + resultSet.getString("JobTitle") + " at " + company;
  
                jobs.add(currentJob);
            }
            return jobs;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // get all available applications of a user 
    public ArrayList<Application> getApplications(String username) {
        ArrayList<Application> applications = new ArrayList<>();
        String query = "SELECT ApplicationID, Status, JobID, ResumeID FROM Application WHERE Username = ?";

        try {
            // PreparedStatement to prevent SQL injection
            PreparedStatement statement = conn1.prepareStatement(query);
            statement.setString(1, username);

            // Execute the query
            ResultSet resultSet = statement.executeQuery();

            // Iterate through the result set
            while (resultSet.next()) {
                int applicationID = resultSet.getInt("ApplicationID");
                String status = resultSet.getString("Status");
                String jobID = resultSet.getString("JobID");
                // Get the name of the job
                String getJob = "SELECT JobTitle FROM JobListing where JobID=?";
                PreparedStatement statement2 = conn1.prepareStatement(getJob);
                statement2.setString(1, jobID);
                ResultSet resultSet2 = statement2.executeQuery();
                resultSet2.next();
                String jobName = resultSet2.getString("JobTitle");
                
                int resumeID = resultSet.getInt("ResumeID");

                // Create a new Application object
                Application application = new Application(applicationID, status, username, jobName, jobID, resumeID);

                // Add it to the list
                applications.add(application);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return applications;
    }
    
    // Return the type of the user 
    public String userType(String username) {
        try {
            String query = "SELECT * FROM UserInfo where username=?";
            PreparedStatement statement = conn1.prepareStatement(query);
            statement.setString(1, username);
            ResultSet result = statement.executeQuery();
            // skip over password col
            result.next();
            
            return result.getString("type");
        } catch (SQLException e) {
            return "Error.";
        }
    }
    
    // Update user profile 
    public boolean updateUserInfo(String username, String phoneNumber, String fullName, String userLocation) {
        try {
            // Get password from UserInfo
            String query = "SELECT * FROM UserInfo where username=?";
            PreparedStatement statement = conn1.prepareStatement(query);
            statement.setString(1, username);
            ResultSet result = statement.executeQuery();
            // Move to first row 
            result.next();
            String password = result.getString("password");
            // If query exists, delete it 
            int rows = statement.executeUpdate();
            if (rows > 0) {
                String delete = "DELETE from UserProfile where username =?";
                PreparedStatement deleteStatement = conn1.prepareStatement(delete);
                deleteStatement.setString(1, username);
                deleteStatement.executeQuery();
            } 
            
            // Create new query with updated info and insert into UserProfile
            String query2 = "INSERT INTO UserProfile(Username, PhoneNumber, Password, FullName, UserLocation) Values(?,?,?,?,?)";
            PreparedStatement statement2 = conn1.prepareStatement(query2);
            statement2.setString(1, username);
            statement2.setString(2, phoneNumber);
            statement2.setString(3, password);
            statement2.setString(4, fullName);
            statement2.setString(5, userLocation); 
            statement2.executeQuery();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }   
}
    
    // Registers a user as an applicant, boolean returned indicating of success/failure 
    public boolean register(String username, String password) {
        try {
            String query ="INSERT INTO UserInfo(Username, Password, Type) Values(?, ?, 'applicant')";
            
            // PreparedStatement to run query
            PreparedStatement statement = conn1.prepareStatement(query);
            statement.setString(1, username);
            statement.setString(2, password);
            
            // Also insert into JobSeeker
            String query2="INSERT INTO JobSeeker(Username) Values(?)";
            PreparedStatement statement2 = conn1.prepareStatement(query2);
            statement2.setString(1, username);
            statement2.executeQuery();
            
            // Result
            int rows = statement.executeUpdate();
            
            // If more than one row was inserted, success
            return rows > 0;
  
            
        } catch (SQLException e) {
                return false;
        }
    }
    
    // Check if a user is registered to our job bank, if they are provides WHAT type, else provides error msg 
    public String userType(String username, String password) {
        try {
            // forming query 
            String query = "SELECT * FROM UserInfo WHERE username=? AND password=?";
            
            // PreparedStatement to run query 
            PreparedStatement statement = conn1.prepareStatement(query);
            statement.setString(1, username);
            statement.setString(2, password);
            
            // Get result of query 
            ResultSet result = statement.executeQuery();
            
            // By default assume that 
            String type = "Try again. Invalid credentials provided.";
            
            if (result.next()) {
                type = result.getString("type");
            }

            return type;
            
        } catch (SQLException e) {
            // Display error message and just assume credentials failed
            return "Try again. Invalid credentials provided.";
        }
    }
    
}
