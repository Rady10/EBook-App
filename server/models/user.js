const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
    },
    address: {
        type: String,
        default: ''
    },
    type: {
        type: String,
        default: 'user'
    }
});

module.exports = mongoose.model('User', userSchema);