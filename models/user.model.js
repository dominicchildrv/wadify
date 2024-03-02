const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require("bcrypt");

const { Schema } = mongoose;


const userSchema = new Schema({
    email:{
        type:String,
        required:[true, "Email cannot be blank"],
        lowercase:true,
        unique:true,
        match: [/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
        "userName format is not correct",]
    },
    password:{
        type:String,
        required:[true, "Password cannot be blank"]

    },
    name:{
        first:{
            type:String,
            trim:true

        },
        last: {
            type:String,
            trim:true
        }
    },
    sex: {
        type: String,
        enum: ['Male', 'Female'] // Ensures the value is one of these two
      },
      

    age:{
        type: Number
    }

});

userSchema.pre('save',async function(){
    try{
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);

        user.password = hashpass;
    } catch (errpr) {
        throw error;
    }
});

userSchema.methods.comparePassword = async function(userPassword){
    try {

        const isMatch = await bcrypt.compare(userPassword, this.password)
        return isMatch;

    } catch (error) {
        throw error;
    }
}

// find by token
userSchema.statics.findByToken=function(token,cb){
    var user=this;

    jwt.verify(token,confiq.SECRET,function(err,decode){
        user.findOne({"_id": decode, "token":token},function(err,user){
            if(err) return cb(err);
            cb(null,user);
        })
    })
};

//delete token

userSchema.methods.deleteToken=function(token,cb){
    var user=this;

    user.update({$unset : {token :1}},function(err,user){
        if(err) return cb(err);
        cb(null,user);
    })
}

const UserModel = db.model('user', userSchema);

module.exports = UserModel;