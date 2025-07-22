const express = require('express');

const auhtController = require('../controllers/auth');
const auth = require('../middlewares/auth');

const router = express.Router();

router.post('/api/signup', auhtController.signup);

router.post('/api/login', auhtController.login);

router.post('/token',auhtController.tokenHandler);

router.get('/', auth, auhtController.getUser);


module.exports = router;