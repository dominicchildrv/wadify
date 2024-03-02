const UserService = require("../services/user.services");


const UserModel = require('../models/user.model'); // Ensure this path is correct

exports.register = async(req, res, next)=>{
    try{
        const {email, password} = req.body;

        // Check if user already exists
        const user = await UserService.checkuser(email);

        if(user){
            return res.status(400).json({status:false, message: 'User already exists'});
        }


        const successRes = await UserService.registerUser(email,password);
        res.status(200).json({status:true, message:"User Registered Successfully"});
    }catch (error){
        next(new Error('Failed to register'));
    }
};





exports.login = async(req,res,next)=>{
    try{
        const {email, password} = req.body;

        const user = await UserService.checkuser(email);

        if(!user){
            return res.status(404).json({status:false, message: 'User does not exist'});
        }

        const isMatch = await user.comparePassword(password);
        if(isMatch === false){
            return res.status(401).json({status:false, message: 'Incorrect password'});
        }

        let tokenData = {_id:user._id,email:user.email};

        const token = await UserService.generateToken(tokenData, "secretKey", '1h')

        res.status(200).json({status:true, token:token})
        
    }catch (error){
        next(error);
    }
}


exports.logout = async(req, res, next) => {
    try {
        // You might want to implement token invalidation here if you opt for a blacklist approach.
        res.status(200).json({status: true, message: "Logged out successfully"});
    } catch (error) {
        next(error);
    }
};





