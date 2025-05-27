const Post = require('../models/postModel');
const User = require('../models/userModel');

async function getAllPosts(request, reply) {
  const posts = await Post.find({});
  reply.send(posts);
}

async function getPostById(request, reply) {
  const { id } = request.params;
  const post = await Post.findById(id);
  if (!post) {
    return reply.code(404).send({ error: 'Post not found' });
  }
  reply.send(post);
}

async function createPost(request, reply) {
  const { title, content, imageURL, author } = request.body;
  const postauthor = await User.findOne({ _id: author });
  if (!postauthor) {
    return reply.code(404).send({ error: 'User not found' });
  }  
  const post = new Post({ title, content,imageURL, author: postauthor});
  await post.save();
  reply.code(201).send(post);
}

async function updatePost(request, reply) {
  const { id } = request.params;
  const updates = request.body;
  const updated = await Post.findByIdAndUpdate(id, updates, { new: true });
  if (!updated) {
    return reply.code(404).send({ error: 'Post not found' });
  }
  reply.send(updated);
}

async function deletePost(request, reply) {
  const { id } = request.params;
  const deleted = await Post.findByIdAndDelete(id);
  if (!deleted) {
    return reply.code(404).send({ error: 'Post not found' });
  }
  reply.code(204).send();
}

module.exports = { getAllPosts, getPostById, createPost, updatePost, deletePost };
