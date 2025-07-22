const express = require('express');

const bookController = require('../controllers/book');

const router = express.Router();

router.get('/api/products/search/:name', bookController.searchBooks);
router.get('/api/all-books', bookController.getAllBooks);

module.exports = router;