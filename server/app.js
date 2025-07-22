const express = require('express');
const mongoose = require('mongoose')

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const bookRoutes = require('./routes/book');
const cartRoutes = require('./routes/cart');
const wishlistRoutes = require('./routes/wishlist');

const PORT = 3000;
const MONGODB_URI = 'mongodb+srv://Rady:Rady1234@shopcluster.qum9xaa.mongodb.net/ebook?retryWrites=true&w=majority&appName=ShopCluster';


const app = express();


app.use(express.json());
app.use(authRoutes);
app.use(userRoutes);
app.use(bookRoutes);
app.use(cartRoutes);
app.use(wishlistRoutes);


mongoose
    .connect(MONGODB_URI)
    .then(result => {
        console.log('Database Connected!')
    })
    .catch(err => {
        console.log(err);
    });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Connected At Port ${PORT}`);
});