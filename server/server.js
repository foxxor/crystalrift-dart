#!/usr/bin/env node
var app = require('./app');
var port = process.env.PORT || 8080;

app.set('port', port);

app.listen(port, function() {
  console.log('Application is available at http://localhost:' + port);
});
