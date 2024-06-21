const LocalStrategy = require('passport-local').Strategy;
const bcrypt = require('bcryptjs');
const connection = require('./database');

module.exports = function(passport) {
  passport.use(
    new LocalStrategy((username, password, done) => {
      connection.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
        if (err) throw err;
        if (results.length === 0) return done(null, false, { message: 'Incorrect username.' });

        const user = results[0];

        bcrypt.compare(password, user.password, (err, isMatch) => {
          if (err) throw err;
          if (isMatch) return done(null, user);
          else return done(null, false, { message: 'Incorrect password.' });
        });
      });
    })
  );

  passport.serializeUser((user, done) => {
    done(null, user.id);
  });

  passport.deserializeUser((id, done) => {
    connection.query('SELECT * FROM users WHERE id = ?', [id], (err, results) => {
      if (err) throw err;
      done(null, results[0]);
    });
  });
};
