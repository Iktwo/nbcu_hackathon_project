var express = require('express');
var ParseServer = require('parse-server').ParseServer;

var app = express();
var api = new ParseServer({
      databaseURI: 'mongodb://nbcuhack',
      cloud: './cloud/main.js',
      appId: 'nbcuhackAppId',
      fileKey: 'nbcuhackFileKey',
      masterKey: 'nbcuhackSecretKey'//,
      //push: { ... }, // See the Push wiki page
      //filesAdapter: ...,
});

// Serve the Parse API at /parse URL prefix
app.use('/parse', api);

var port = 1337;
app.listen(port, function() {
  console.log('parse-server-example running on port ' + port + '.');
});
