const Wishlist = require('../models/wishlist');
const Book = require('../models/book');

exports.getWishlist = async (req, res) => {
    try {
        const userId = req.params.userId;
        let wishlist = await Wishlist.findOne({ user: userId }).populate('books');
        if (!wishlist) {
            wishlist = new Wishlist({ user: userId, books: [] });
            await wishlist.save();
        }
        res.json(wishlist.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.addToWishlist = async (req, res) => {
    try {
        const userId = req.params.userId;
        const { bookId } = req.body;
        let wishlist = await Wishlist.findOne({ user: userId });
        if (!wishlist) {
            wishlist = new Wishlist({ user: userId, books: [] });
        }
        if (!wishlist.books.includes(bookId)) {
            wishlist.books.push(bookId);
            await wishlist.save();
        }
        await wishlist.populate('books');
        res.json(wishlist.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.removeFromWishlist = async (req, res) => {
    try {
        const userId = req.params.userId;
        const bookId = req.params.bookId;
        const wishlist = await Wishlist.findOne({ user: userId });
        if (!wishlist) {
            return res.status(404).json({ error: 'Wishlist not found' });
        }
        wishlist.books = wishlist.books.filter(id => id.toString() !== bookId);
        await wishlist.save();
        await wishlist.populate('books');
        res.json(wishlist.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}; 