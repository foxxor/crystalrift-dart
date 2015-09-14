var express = require('express');
var logger = require('morgan');
var path = require('path');
var app = express();

app.use(logger('dev'));
app.use(express.static(path.join(__dirname, '../web')));

module.exports = app;
