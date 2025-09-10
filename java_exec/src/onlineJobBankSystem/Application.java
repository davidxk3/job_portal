/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package onlineJobBankSystem;

/**
 *
 * @author David
 */
public class Application {
        public int applicationID;
        public String status;
        public String username;
        public String jobID;
        public String jobName;
        public int resumeID;

        public Application(int applicationID, String status, String username, String jobID, String jobName, int resumeID) {
            this.applicationID = applicationID;
            this.status = status;
            this.username = username;
            this.jobID = jobID;
            this.jobName = jobName;
            this.resumeID = resumeID;
        }
}

