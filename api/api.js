var express = require('express');

var Parse = require('node-parse-api').Parse;

var options = {
	app_id: 'UPJFfR8GO7kXYFPicuKK0mdakfcL73vU4PwzsiV9',
	api_key: 'lUbm8jUTe7efq4dbgzV88bMoZ1G2kE1TPDB6V0Sk'
}

var parse = new Parse(options);

parse.loginUser('test', 'test', function (error, response) {
  // response = {sessionToken: '', createdAt: '', ... } 
  console.log(response);
});

var app = express();

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
	res.status(200).send('nbcuhack');
});

var port = 1337;
app.listen(port, function() {
	console.log('example running on port ' + port + '.');
});
