const Book = require('../models/book');


exports.addBook = async (req, res) => {
    try {
        const {name, author , description, price, image, userId } = req.body;
        let book = new Book({
            name: name,
            description: description,
            author: author,
            price: price,
            image: image,
            user: userId
        });
        book = await book.save();
        res.json(book); 
    } catch (err) {
        res.status(500).json({
            error: err.message
        })
    }
}

exports.getBooks = async (req, res) => {
    try {
        const user = req.header('user-id');
        const books = await Book.find({user: user});
        res.json(books);
    } catch(err) {
        res.status(500).json({
            error: err.message
        })
    }
}

exports.deleteBook = async (req, res) => {
    try {
        const { id } = req.body;
        let book = await Book.findByIdAndDelete(id);
        res.json('Book Deleted');
    } catch (err) {
        res.status(500).json({
            error: err.message
        })
        console.log(err.message);
    }
}