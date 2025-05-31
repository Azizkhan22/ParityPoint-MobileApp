const { getUserProfile, updateUserImage, searchUsers, followUser, unfollowUser } = require('../controllers/userController');
const { verifyJWT } = require('../utils/jwt');

async function userRoutes(fastify, options) {
  fastify.get('/search',  searchUsers);
  fastify.get('/profile', getUserProfile);  
  fastify.post('/update-image', updateUserImage);
  fastify.post('/follow', followUser);
  fastify.post('/unfollow', unfollowUser);
  
}

module.exports = userRoutes;