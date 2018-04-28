#!/usr/bin/env node
var webServer = require( './webServer' )( '../docs/web' );
var port = process.env.PORT || 9099;

webServer.set( 'port', port );

webServer.listen(port, function() {
  console.log( 'Application is available at http://localhost:' + port );
});