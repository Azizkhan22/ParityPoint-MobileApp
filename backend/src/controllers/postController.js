const Post = require('../models/postModel');
const User = require('../models/userModel');

async function getAllPosts(request, reply) {  
  const { userId } = request.body;    
  const user = await User.findById(userId);    
  if (user) {    
    const userBlogs = await Post.find({author: user}).populate('author', 'name image');
    const following = user.following;    
    const followingBlogs = await Post.find({ author: { $in: following } }).populate('author', 'name image');    
    const allBlogs = await Post.find({}).populate('author', 'name image');      
    const programmingKeywords = [
      'javascript', 'python', 'java', 'coding', 'programming',
      'developer', 'software', 'web', 'api', 'database',
      'frontend', 'backend', 'fullstack', 'algorithm', 'code',
      'framework', 'library', 'debugging', 'testing', 'devops'
    ];    
    const programmingBlogs = allBlogs.filter(post => {
      return programmingKeywords.some(keyword => 
        post.title.toLowerCase().includes(keyword)
      );
    });    
    const twoDaysAgo = new Date();
    twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);    
    const recentBlogs = allBlogs.filter(post => new Date(post.createdAt) >= twoDaysAgo);    
    reply.code(201).send({userBlogs, followingBlogs, programmingBlogs, recentBlogs, allBlogs})    
  } else {    
    reply.code(404).send({error: "User not found"});    
  }

}

async function getAllPosts(request, reply) {
  try {
    const posts = await Post.find({})
      .populate('author', 'name image')
      .sort({ createdAt: -1 })
      .limit(10);

    return reply.code(200).send(posts);
  } catch (error) {
    return reply.code(500).send({ error: error.message });
  }
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
