const express = require('express');
const logger = require('morgan');
const path = require('path');
	
module.exports = function ( directory ) {
	let module = express();

	module.use( logger('dev') );
	module.use( express.static( path.join( __dirname, directory ) ) );

	return module;
}