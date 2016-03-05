var express = require('express');
var ParseServer = require('parse-server').ParseServer;

var app = express();
var api = new ParseServer({
	databaseURI: 'mongodb://127.0.0.1:27017',
      appId: 'nbcuhackAppId',
      fileKey: 'nbcuhackFileKey',
      masterKey: 'nbcuhackSecretKey',
      serverURL: 'http://localhost:1337'
});

// Serve the Parse API at /parse URL prefix
app.use('/parse', api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('nbcuhack');
});

var port = 1337;
app.listen(port, function() {
  console.log('parse-server-example running on port ' + port + '.');
});
