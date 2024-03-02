// auth.js
const jwt = require('jsonwebtoken');
const UserModel = require('./models/user.model'); // Adjust the path according to your structure

const auth = async (req, res, next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ', '');
        const decoded = jwt.verify(token, 'secretKey'); // Replace 'secretKey' with your actual secret key
        const user = await UserModel.findOne({ _id: decoded._id, 'tokens.token': token });

        if (!user) {
            throw new Error();
        }

        req.token = token;
        req.user = user;
        next();
    } catch (error) {
        res.status(401).send({ error: 'Please authenticate.' });
    }
};

module.exports = auth;
