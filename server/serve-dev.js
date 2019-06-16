#!/usr/bin/env node
var webServer = require( './webServer' )( '../build' );
var port = process.env.PORT || 8080;

webServer.set( 'port', port );

webServer.listen(port, function() {
  console.log( 'Application is available at http://localhost:' + port );
});
