const { getUserProfile } = require('../controllers/userController');
const { verifyJWT } = require('../utils/jwt');

async function userRoutes(fastify, options) {
  fastify.get('/profile', { preValidation: [verifyJWT] }, getUserProfile);
}

module.exports = userRoutes;
