const express = require('express');
const fs  = require('fs');
const db = require('./config/db');
const MongoClient = require('mongodb').MongoClient;
const assert = require('assert')
var connect = require('connect');
var serveStatic = require('serve-static');
const app = express();

const port = 8000




MongoClient.connect('mongodb://@ds062339.mlab.com:62339/identix', function(err, client) {
  assert.equal(null, err);
  console.log("Connected successfully to server");
 
  const db = client.db('identix');
  require('./app/routes')(app, db);
  

  app.use(express.static(__dirname + '/frontend'));
  app.get('/', (req, res) => {
  res.sendFile(__dirname +'/frontend/cover.html');
  });
  
  app.listen(port, () => {
    console.log('We are live on ' + port);

  connect().use(serveStatic(__dirname + '/frontend')).listen(8080, function(){
    console.log('Server running on 8080...');
	});
  });  
});
