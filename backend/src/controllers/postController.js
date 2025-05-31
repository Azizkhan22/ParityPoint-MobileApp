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

async function getUserProfile(request, reply) {
  try {
    const { userId } = request.body;
    const user = await User.findById(userId);

    if (!user) {
      return reply.code(404).send({ error: "User not found" });
    }

    const posts = await Post.find({ author: userId })
      .populate('author', 'name image');

    const followers = await User.find({ _id: { $in: user.followers } })
      .select('name image _id');

    const following = await User.find({ _id: { $in: user.following } })
      .select('name image _id');

    reply.code(200).send({
      posts,
      followers,
      following,
      user: {
        id: user._id,
        name: user.name,
        image: user.image
      }
    });
  } catch (error) {
    reply.code(500).send({ error: error.message });
  }
}

async function getHomePosts(request, reply) {
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

async function getOtherUserProfile(request, reply) {
  try {
    const { userId, currentUserId } = request.body;
    console.log(request.body);
    const user = await User.findById(userId);

    if (!user) {
      return reply.code(404).send({ error: "User not found" });
    }

    // Get user's posts
    const posts = await Post.find({ author: userId })
      .populate('author', 'name image')
      .sort({ createdAt: -1 });

    // Get current user to check if they're following
    const currentUser = await User.findById(currentUserId);
    const isFollowing = currentUser.following.includes(userId);

    // Get user data
    const userData = {
      _id: user._id,
      name: user.name,
      image: user.image,
      followers: user.followers.length,
      following: user.following.length
    };

    reply.code(200).send({
      posts,
      userData,
      isFollowing
    });

  } catch (error) {
    reply.code(500).send({ error: error.message });
  }
}

// Add to module.exports
module.exports = { 
  getAllPosts, 
  getPostById, 
  getUserProfile, 
  getHomePosts, 
  createPost, 
  updatePost, 
  deletePost,
  getOtherUserProfile 
};
