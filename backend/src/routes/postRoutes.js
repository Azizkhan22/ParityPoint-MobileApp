const {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost
} = require('../controllers/postController');

async function postRoutes(fastify, options) {
  fastify.get('/', getAllPosts);
  fastify.get('/:id', getPostById);
  fastify.post('/', createPost);
  fastify.put('/:id', updatePost);
  fastify.delete('/:id', deletePost);
}

module.exports = postRoutes;
