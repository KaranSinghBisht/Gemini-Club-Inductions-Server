const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const session = require('express-session');
const path = require('path');
const app = express();

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public'))); // Serve static files from the 'public' directory

app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));

// MySQL connection configuration
const db_config = {
  host: 'db',
  user: 'root',
  password: 'root',
  database: 'mydatabase',
  port: 3306 // Ensure the port matches your Docker setup
};

let connection;

function handleDisconnect() {
  connection = mysql.createConnection(db_config);

  connection.connect(function (err) {
      if (err) {
          console.log('Error connecting to database:', err);
          setTimeout(handleDisconnect, 2000);
      } else {
          console.log('Connected to database');
      }
  });

  connection.on('error', function (err) {
      if (err.code === 'PROTOCOL_CONNECTION_LOST') {
          handleDisconnect();
      } else {
          throw err;
      }
  });
}

handleDisconnect();

// Routes
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html')); // Serve the login page
});

// Handle login
app.post('/login', (req, res) => {
  const username = req.body.username;
  const password = req.body.password;

  if (username && password) {
    connection.query('SELECT * FROM users WHERE username = ? AND password = ?', [username, password], (err, results) => {
      if (err) throw err;
      if (results.length > 0) {
        req.session.loggedin = true;
        req.session.user = results[0];
        res.redirect('/home');
      } else {
        res.send('Incorrect Username and/or Password!');
      }
    });
  } else {
    res.send('Please enter Username and Password!');
  }
});

app.get('/home', (req, res) => {
  if (req.session.loggedin) {
    res.sendFile(path.join(__dirname, 'public', 'home.html'));
  } else {
    res.send('Please login to view this page!');
  }
});

app.get('/user-details', (req, res) => {
  if (req.session.loggedin) {
    const user = req.session.user;
    if (user.role === 'core') {
      connection.query('SELECT * FROM users', (err, results) => {
        if (err) throw err;
        res.json({ username: user.username, role: user.role, users: results });
      });
    } else if (user.role === 'mentor') {
      connection.query('SELECT * FROM users WHERE domain = ?', [user.domain], (err, results) => {
        if (err) throw err;
        res.json({ username: user.username, role: user.role, mentees: results });
      });
    } else if (user.role === 'mentee') {
      connection.query('SELECT * FROM users WHERE id = ?', [user.id], (err, results) => {
        if (err) throw err;
        res.json({ username: user.username, role: user.role, user: results[0] });
      });
    }
  } else {
    res.sendStatus(401);
  }
});

app.get('/logout', (req, res) => {
  req.session.destroy();
  res.redirect('/login');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
