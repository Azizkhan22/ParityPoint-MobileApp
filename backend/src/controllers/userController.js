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
    
    reply.code(200).send({ message: 'User registered. Please login to proceed.' });
  } catch (err) {
    reply.code(500).send({ error: err.message });
  }
}

module.exports = { getUserProfile, updateUserImage };
