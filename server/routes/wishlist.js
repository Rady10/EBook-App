const express = require('express');
const wishlistController = require('../controllers/wishlist');

const router = express.Router();

router.get('/api/wishlist/:userId', wishlistController.getWishlist);
router.post('/api/wishlist/:userId', wishlistController.addToWishlist);
router.delete('/api/wishlist/:userId/:bookId', wishlistController.removeFromWishlist);

module.exports = router; 