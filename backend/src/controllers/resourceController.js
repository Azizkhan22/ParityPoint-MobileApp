const Resource = require('../models/resourceModel');

async function getAllResources(request, reply) {
  const resources = await Resource.find({});
  reply.send(resources);
}

async function getResourceById(request, reply) {
  const { id } = request.params;
  const resource = await Resource.findById(id);
  if (!resource) {
    return reply.code(404).send({ error: 'Resource not found' });
  }
  reply.send(resource);
}

async function createResource(request, reply) {
  const { title, content, category } = request.body;
  const resource = new Resource({ title, content, category });
  await resource.save();
  reply.code(201).send(resource);
}

async function updateResource(request, reply) {
  const { id } = request.params;
  const updates = request.body;
  const updated = await Resource.findByIdAndUpdate(id, updates, { new: true });
  if (!updated) {
    return reply.code(404).send({ error: 'Resource not found' });
  }
  reply.send(updated);
}

async function deleteResource(request, reply) {
  const { id } = request.params;
  const deleted = await Resource.findByIdAndDelete(id);
  if (!deleted) {
    return reply.code(404).send({ error: 'Resource not found' });
  }
  reply.code(204).send();
}

module.exports = { getAllResources, getResourceById, createResource, updateResource, deleteResource };
