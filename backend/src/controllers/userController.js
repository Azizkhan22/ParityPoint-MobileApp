const User = require('../models/userModel');

async function getUserProfile(request, reply) {
  const userId = request.user.userId;
  const user = await User.findById(userId).select('-password -emailToken');
  if (!user) {
    return reply.code(404).send({ error: 'User not found' });
  }
  reply.send(user);
}

module.exports = { getUserProfile };
