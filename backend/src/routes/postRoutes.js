const {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost,
  getHomePosts,
  getUserProfile,
  getOtherUserProfile
} = require('../controllers/postController');

async function postRoutes(fastify, options) {
  fastify.post('/get-posts', getAllPosts);
  fastify.post('/user-page', getUserProfile);
  fastify.post('/other-user', getOtherUserProfile);
  fastify.get('/', getHomePosts);
  fastify.get('/:id', getPostById);
  fastify.post('/', createPost);
  fastify.put('/:id', updatePost);
  fastify.delete('/:id', deletePost);
}

module.exports = postRoutes;
