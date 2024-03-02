const mongoose = require(`mongoose`);


const connection = mongoose.createConnection('mongodb+srv://dominic:Storypassword@appcluster.e3miaef.mongodb.net/newToDo').on('open', ()=>{
    console.log("MongoDB Connected");
}).on('error', ()=>{
    console.log("MongoDB Connection error");
});

module.exports = connection;