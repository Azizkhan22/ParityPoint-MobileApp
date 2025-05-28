const {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost
} = require('../controllers/postController');

async function postRoutes(fastify, options) {
  fastify.post('/get-posts', getAllPosts);
  fastify.get('/:id', getPostById);
  fastify.post('/', createPost);
  fastify.put('/:id', updatePost);
  fastify.delete('/:id', deletePost);
}

module.exports = postRoutes;
