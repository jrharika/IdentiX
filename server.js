var express = require('express');
var app = express();
var fs  = require('fs');

app.use(express.static(__dirname + '/frontend'));



app.get('/', (req, res) => {
  res.sendFile(__dirname +'/frontend/index.html');
});

app.post('/setUser', function(req, res, next) {
	console.log(req);
});

var server = app.listen(8080, function() {
	var host = server.address().address;
	var port = server.address().port;
	console.log('Server listening at %s:%s', host, port);
});
