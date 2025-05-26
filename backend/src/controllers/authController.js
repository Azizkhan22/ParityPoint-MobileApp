const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const nodemailer = require('nodemailer');

const JWT_SECRET = process.env.JWT_SECRET || 'supersecretjwtkey';
const EMAIL_FROM = process.env.EMAIL_FROM || 'no-reply@example.com';

// Nodemailer setup (simple example)
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

async function sendVerificationEmail(user, token) {
  const url = `${process.env.FRONTEND_URL}/verify-email?token=${token}`;
  await transporter.sendMail({
    from: EMAIL_FROM,
    to: user.email,
    subject: 'Verify your email',
    html: `<p>Click <a href="\${url}">here</a> to verify your email.</p>`,
  });
}

async function register(request, reply) {
  try {
    const { name, email, password } = request.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return reply.code(400).send({ error: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const emailToken = crypto.randomBytes(32).toString('hex');

    const newUser = new User({
      name,
      email,
      password: hashedPassword,      
      emailToken,
      image: 'assets/images/avatar.png', 
    });

    await newUser.save();    

    reply.code(201).send({ message: 'User registered. Please login to proceed.' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

async function verifyEmail(request, reply) {
  try {
    const { token } = request.query;
    if (!token) {
      return reply.code(400).send({ error: 'Token missing' });
    }
    const user = await User.findOne({ emailToken: token });
    if (!user) {
      return reply.code(400).send({ error: 'Invalid token' });
    }
    user.isVerified = true;
    user.emailToken = null;
    await user.save();
    reply.send({ message: 'Email verified successfully' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

async function login(request, reply) {
  try {    
    const { email, password } = request.body;
    const user = await User.findOne({ email });
    if (!user) {
      return reply.code(400).send({ error: 'Invalid email or password' });
    }    
    const validPass = await bcrypt.compare(password, user.password);
    if (!validPass) {
      return reply.code(400).send({ error: 'Invalid email or password' });
    }
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '7d' });    
    const { name, followers, following, image } = user;
    const userData = {      
      name,
      email,
      followers,
      following,
      image      
    };
    reply.code(201).send({ token, userData });    
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

module.exports = { register, verifyEmail, login };
