const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const User = require('../models/user');

exports.signup = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email: email });
    if (existingUser) {
      return res.status(400).json({
        msg: "User with same email already exists!",
      });
    }
    const hashedPassword = await bcrypt.hash(password, 12);

    const user = new User({
      email: email,
      name: name,
      password: hashedPassword,
    });

    const result = await user.save();

    res.json(result);
  } catch (err) {
    res.status(500).json({
      error: err.message,
    });
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email: email });
    if (!user) {
      res.status(400).json({
        msg: "Wrong Email or Password",
      });
    }
    const isEqual = await bcrypt.compare(password, user.password);
    if (!isEqual) {
      res.status(400).json({
        msg: "Wrong Email or Password",
      });
    }

    const token = await jwt.sign(
      {
        _id: user._id,
        email: user.email,
      },
      'passwordJwtKey',
    );
    res.status(200).json({ token, ...user._doc });
    req.user = user;
  } catch (err) {
    res.status(500).json({
      error: err.message
    })
  }
};

exports.tokenHandler = async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

exports.getUser = async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
}
