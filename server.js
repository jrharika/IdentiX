var express = require('express');
var app = express();
var fs  = require('fs');

app.get('/getUser', function(req, res) {
	res.end('Hello World');
});

app.post('/setUser', function(req, res, next) {
	console.log(req);
});

var server = app.listen(8080, function() {
	var host = server.address().address;
	var port = server.address().port;
	console.log('Server listening at %s:%s', host, port);
});

