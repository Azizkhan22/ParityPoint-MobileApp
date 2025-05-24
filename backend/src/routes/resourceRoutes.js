const {
  getAllResources,
  getResourceById,
  createResource,
  updateResource,
  deleteResource
} = require('../controllers/resourceController');
const { verifyJWT } = require('../utils/jwt');

async function resourceRoutes(fastify, options) {
  fastify.get('/', getAllResources);
  fastify.get('/:id', getResourceById);
  fastify.post('/', { preValidation: [verifyJWT] }, createResource);
  fastify.put('/:id', { preValidation: [verifyJWT] }, updateResource);
  fastify.delete('/:id', { preValidation: [verifyJWT] }, deleteResource);
}

module.exports = resourceRoutes;
