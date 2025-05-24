const Category = require('../models/categoryModel');

async function getAllCategories(request, reply) {
  const categories = await Category.find({});
  reply.send(categories);
}

async function getCategoryById(request, reply) {
  const { id } = request.params;
  const category = await Category.findById(id);
  if (!category) {
    return reply.code(404).send({ error: 'Category not found' });
  }
  reply.send(category);
}

async function createCategory(request, reply) {
  const { name, description } = request.body;
  const category = new Category({ name, description });
  await category.save();
  reply.code(201).send(category);
}

async function updateCategory(request, reply) {
  const { id } = request.params;
  const updates = request.body;
  const updated = await Category.findByIdAndUpdate(id, updates, { new: true });
  if (!updated) {
    return reply.code(404).send({ error: 'Category not found' });
  }
  reply.send(updated);
}

async function deleteCategory(request, reply) {
  const { id } = request.params;
  const deleted = await Category.findByIdAndDelete(id);
  if (!deleted) {
    return reply.code(404).send({ error: 'Category not found' });
  }
  reply.code(204).send();
}

module.exports = { getAllCategories, getCategoryById, createCategory, updateCategory, deleteCategory };
