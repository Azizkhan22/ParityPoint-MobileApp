const {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost
} = require('../controllers/postController');
const { verifyJWT } = require('../utils/jwt');

async function postRoutes(fastify, options) {
  fastify.get('/', getAllPosts);
  fastify.get('/:id', getPostById);
  fastify.post('/', { preValidation: [verifyJWT] }, createPost);
  fastify.put('/:id', { preValidation: [verifyJWT] }, updatePost);
  fastify.delete('/:id', { preValidation: [verifyJWT] }, deletePost);
}

module.exports = postRoutes;
