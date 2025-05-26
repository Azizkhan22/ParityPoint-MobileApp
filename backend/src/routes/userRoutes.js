const { getUserProfile, updateUserImage } = require('../controllers/userController');
const { verifyJWT } = require('../utils/jwt');

async function userRoutes(fastify, options) {
  
  fastify.get('/profile', getUserProfile);
  fastify.post('/update-image', updateUserImage)
  
}

module.exports = userRoutes;