// app.js

const express = require('express');
const bodyParser = require('body-parser');
const userRouter = require('./routers/user.router');
const errorHandler = require('./errorhandler'); // Import the error handling middleware

const app = express();

app.use(bodyParser.json());

app.use('/', userRouter);

// Error handling middleware
app.use(errorHandler);

module.exports = app;
