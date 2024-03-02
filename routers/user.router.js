const router = require('express').Router();
const UserController = require("../controller/user.controller")
const { body, validationResult } = require('express-validator');
const auth = require('../auth'); 

router.post('/registration', [
    body('email').isEmail().withMessage('Enter a valid email address'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
                   .matches(/\d/).withMessage('Password must contain a number')
                   .matches(/[a-z]/).withMessage('Password must contain a lowercase letter')
                   .matches(/[A-Z]/).withMessage('Password must contain an uppercase letter'),
  ], (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }
    UserController.register(req, res, next);
  });

router.post('/login',UserController.login);

// user.router.js

router.post('/logout', UserController.logout);



module.exports = router;



