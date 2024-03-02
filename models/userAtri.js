const db = require('../config/db');
const UserModel = require("./user.model");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const userAttributes = new Schema({
    userId:{
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName
    },
    date:{
        type: Date,
        required: true

    },
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
},{timestamps:true});
const ToDoModel = db.model('todo',toDoSchema);
module.exports = ToDoModel;