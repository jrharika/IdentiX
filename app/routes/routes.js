module.exports = function(app, db) {

  app.post('/setUser', (req, res) => {
    res.send("<button>Hello World!</button>");
  });

  app.post('/getUser', (req, res) => {
    res.send("<button>LOLLL!</button>");
  });
};