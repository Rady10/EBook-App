const express = require('express');

const userController = require('../controllers/user');

const router = express.Router();

router.post('/api/addBook', userController.addBook);

router.get('/api/books', userController.getBooks);

router.post('/api/delete', userController.deleteBook);


module.exports = router;