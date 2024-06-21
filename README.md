# Gemini-Club-Inductions-Server
Welcome to the Gemini Club Inductions Server repository! This repository hosts essential scripts designed for configuring an induction management server. These scripts streamline the induction process for new members by offering key functionalities accessible via command-line aliases.

## Setup Instructions
1. **Clone the repository**:
    ```bash
    git clone https://github.com/KaranSinghBisht/Gemini-Club-Inductions-Server.git
    cd Gemini-Club-Inductions-Server
    ```

2. **Build and run the Docker containers**:
    ```bash
    docker-compose up --build -d
    ```
## Webpages Access
### Login Page
Access the login page where users can log in with their credentials.
- **URL**: [http://localhost:5000/login](http://localhost:5000/login)
- **Sample Login Credentials**:
  - **Core User**: 
    - Username: `DAdmin`
    - Password: `password123`
  - **Mentor User**:
    - Username: `john_mentor`
    - Password: `password123`
  - **Mentee User**:
    - Username: `jane_mentee`
    - Password: `password123`

### Home Page
After logging in, users are redirected to the home page. The displayed user details depend on the logged-in user's role.
- **URL**: [http://localhost:5000/home](http://localhost:5000/home)

### User Details
Different users have different levels of access:
- **Core Users**: Can see all users' details.
- **Mentors**: Can see only their mentees' details.
- **Mentees**: Can see only their own details.

### PHPMyAdmin
PHPMyAdmin is available for viewing the database and performing database operations.
- **URL**: [http://localhost:9090](http://localhost:9090)
- **Login**: Use the MySQL root credentials set in `docker-compose.yml`.

## Important Scripts
### To Implement the Cronjob
```bash
crontab -e

# Run displayStatus script daily
0 0 * * * displayStatus.sh
# Run cleanupDeregistered script every three days and Sundays at 10:10 AM in May, June, and July
10 10 */3,7 5-7 * cleanupDeregistered.sh
```
setQuiz
To notify mentees about the new quiz and prompt them to answer questions, we can modify their shell profile to call the setQuiz.sh script on login.

Add the following line to the .bashrc file of each mentees:

bash
Copy code
/path/to/setQuiz.sh
This will ensure that the script runs every time the mentee logs in, displaying the quiz questions if available.

### setQuiz
To notify mentees about the new quiz and prompt them to answer questions, we can modify their shell profile to call the `setQuiz.sh` script on login.

Add the following line to the `.bashrc` file of each mentees:
```bash
/path/to/setQuiz.sh
```
This will ensure that the script runs every time the mentee logs in, displaying the quiz questions if available. 

### Directory Structure
```
Gemini-Club-Inductions-Server/
├── Dockerfile
├── docker-compose.yml
├── init.sql
└── gemini-inductions/
    ├── app.js
    ├── config/
    ├── controllers/
    ├── Dockerfile
    ├── middleware/
    │   └── auth.js
    ├── models/
    ├── node_modules/
    ├── package.json
    ├── package-lock.json
    ├── public/
    │   ├── login.html
    │   ├── style.css
    │   └── home.html
    └── routes/
```
### Additional Information
#### Database Configuration: 
The database configuration is set in the `docker-compose.yml` file. Make sure to update it according to your setup.

#### Server Port: 
The Node.js server runs on port `5000`. This can be configured in the `app.js` file.
