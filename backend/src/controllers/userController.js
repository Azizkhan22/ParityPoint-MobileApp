const User = require('../models/userModel');



async function getUserProfile(request, reply) {
  const userId = request.user.userId;
  const user = await User.findById(userId).select('-password -emailToken');
  if (!user) {
    return reply.code(404).send({ error: 'User not found' });
  }
  reply.send(user);
}
async function updateUserImage(request, reply) {
  try {    
    const { email, imageURL } = request.body;    
    const updatedUser = await User.findOneAndUpdate(
      { email: email },
      { image: imageURL },
      { new: true }
    );
    
    reply.code(200).send({ message: 'Image uploaded successfully' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

async function searchUsers(request, reply) {
  try {
    const { query, userId } = request.query;

    // Find the current user to get their following list
    const currentUser = await User.findById(userId);
    if (!currentUser) {
      return reply.code(404).send({ error: 'Current user not found' });
    }

    // Find users matching the search query
    const users = await User.find({
      name: { $regex: query, $options: 'i' },
      _id: { $ne: userId } // Exclude current user from results
    }).select('-password -emailToken');

    // Map users to include isFollowing flag
    const usersWithFollowStatus = users.map(user => ({
      ...user.toObject(),
      isFollowing: currentUser.following.includes(user._id)
    }));

    reply.code(200).send({
      users: usersWithFollowStatus,
      following: currentUser.following
    });

  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

async function followUser(request, reply) {
  try {
    const { userId, targetUserId } = request.body;
    
    // Update the user who is following
    await User.findByIdAndUpdate(
      userId,
      { $addToSet: { following: targetUserId } }
    );

    // Update the target user's followers
    await User.findByIdAndUpdate(
      targetUserId,
      { $addToSet: { followers: userId } }
    );

    reply.code(200).send({ message: 'Successfully followed user' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

async function unfollowUser(request, reply) {
  try {
    const { userId, targetUserId } = request.body;
    
    // Remove from following list
    await User.findByIdAndUpdate(
      userId,
      { $pull: { following: targetUserId } }
    );

    // Remove from followers list
    await User.findByIdAndUpdate(
      targetUserId,
      { $pull: { followers: userId } }
    );

    reply.code(200).send({ message: 'Successfully unfollowed user' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

// Update the exports
module.exports = { 
  getUserProfile, 
  updateUserImage, 
  searchUsers,
  followUser,
  unfollowUser
};
