const {
  register,
  verifyEmail,
  login
} = require('../controllers/authController');

async function authRoutes(fastify, options) {
  fastify.post('/register', register);
  fastify.get('/verify-email', verifyEmail);
  fastify.post('/login', login);
}

module.exports = authRoutes;
