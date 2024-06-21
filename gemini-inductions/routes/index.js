router.get('/dashboard', ensureAuthenticated, (req, res) => {
    let query = 'SELECT * FROM users WHERE id = ?';
    let params = [req.user.id];
  
    if (req.user.role === 'core') {
      query = 'SELECT * FROM users';
      params = [];
    } else if (req.user.role === 'mentor') {
      query = 'SELECT * FROM users WHERE role = "mentee" AND mentor_id = ?';
      params = [req.user.id];
    }
  
    connection.query(query, params, (err, results) => {
      if (err) throw err;
  
      let usersTable = `
        <table>
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Role</th>
            <th>Domain</th>
          </tr>
      `;
  
      results.forEach(user => {
        usersTable += `
          <tr>
            <td>${user.id}</td>
            <td>${user.username}</td>
            <td>${user.role}</td>
            <td>${user.domain}</td>
          </tr>
        `;
      });
  
      usersTable += `</table>`;
  
      res.send(`
        <html>
          <head>
            <title>Dashboard</title>
            <link rel="stylesheet" type="text/css" href="/css/styles.css">
          </head>
          <body>
            <div class="container">
              <h1>Welcome, ${req.user.username}</h1>
              <p>Role: ${req.user.role}</p>
              ${usersTable}
              <a href="/logout">Logout</a>
            </div>
          </body>
        </html>
      `);
    });
  });
  