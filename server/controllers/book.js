const Book = require('../models/book');

exports.searchBooks = async (req, res) => {
    try {
        const books = await Book.find({
            name: { $regex: req.params.name, $options: "i" },
        });

        res.json(books);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}

exports.getAllBooks = async (req, res) => {
    try {
        const books = await Book.find();
        res.json(books);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}