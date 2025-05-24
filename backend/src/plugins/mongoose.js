const fastifyPlugin = require('fastify-plugin');
const mongoose = require('mongoose');

async function dbConnector(fastify, options) {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    fastify.log.info('MongoDB connected');
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}

module.exports = fastifyPlugin(dbConnector);
