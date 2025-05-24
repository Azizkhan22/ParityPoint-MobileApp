const {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory
} = require('../controllers/categoryController');
const { verifyJWT } = require('../utils/jwt');

async function categoryRoutes(fastify, options) {
  fastify.get('/', getAllCategories);
  fastify.get('/:id', getCategoryById);
  fastify.post('/', { preValidation: [verifyJWT] }, createCategory);
  fastify.put('/:id', { preValidation: [verifyJWT] }, updateCategory);
  fastify.delete('/:id', { preValidation: [verifyJWT] }, deleteCategory);
}

module.exports = categoryRoutes;
