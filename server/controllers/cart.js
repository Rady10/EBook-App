const Cart = require('../models/cart');
const Book = require('../models/book');

exports.getCart = async (req, res) => {
    try {
        const userId = req.params.userId;
        let cart = await Cart.findOne({ user: userId }).populate('books');
        if (!cart) {
            cart = new Cart({ user: userId, books: [] });
            await cart.save();
        }
        res.json(cart.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.addToCart = async (req, res) => {
    try {
        const userId = req.params.userId;
        const { bookId } = req.body;
        let cart = await Cart.findOne({ user: userId });
        if (!cart) {
            cart = new Cart({ user: userId, books: [] });
        }
        if (!cart.books.includes(bookId)) {
            cart.books.push(bookId);
            await cart.save();
        }
        await cart.populate('books');
        res.json(cart.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.removeFromCart = async (req, res) => {
    try {
        const userId = req.params.userId;
        const bookId = req.params.bookId;
        const cart = await Cart.findOne({ user: userId });
        if (!cart) {
            return res.status(404).json({ error: 'Cart not found' });
        }
        cart.books = cart.books.filter(id => id.toString() !== bookId);
        await cart.save();
        await cart.populate('books');
        res.json(cart.books);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}; 