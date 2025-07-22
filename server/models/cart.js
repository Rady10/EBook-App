const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const cartSchema = new Schema({
    user: {
        type: String,
        required: true,
    },
    books: [{
        type: Schema.Types.ObjectId,
        ref: 'Book',
        required: true
    }]
});

module.exports = mongoose.model('Cart', cartSchema); 