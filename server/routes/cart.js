const express = require('express');
const cartController = require('../controllers/cart');

const router = express.Router();

router.get('/api/cart/:userId', cartController.getCart);
router.post('/api/cart/:userId', cartController.addToCart);
router.delete('/api/cart/:userId/:bookId', cartController.removeFromCart);

module.exports = router; 