# Gemini-Club-Inductions-Server
Welcome to the Gemini Club Inductions Server repository! This repository hosts essential scripts designed for configuring an induction management server. These scripts streamline the induction process for new members by offering key functionalities accessible via command-line aliases.

### To implement the cronjob 
```bash
crontab -e

# Run displayStatus script daily
0 0 * * * displayStatus.sh
# Run cleanupDeregistered script every three days and Sundays at 10:10 AM in May, June, and July
10 10 */3,7 5-7 * cleanupDeregistered.sh
```
### setQuiz
To notify mentees about the new quiz and prompt them to answer questions, we can modify their shell profile to call the `setQuiz.sh` script on login.

Add the following line to the `.bashrc` file of each mentees:
```bash
/path/to/setQuiz.sh
```
This will ensure that the script runs every time the mentee logs in, displaying the quiz questions if available. 
