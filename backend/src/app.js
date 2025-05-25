const fastify = require('fastify')({ logger: true });
require('dotenv').config();
const fastifyCors = require('@fastify/cors');

fastify.register(fastifyCors, {
    origin: true,
});
fastify.register(require('./plugins/mongoose'));
fastify.register(require('./plugins/mailer'));

fastify.register(require('./routes/authRoutes'), { prefix: '/auth' });
fastify.register(require('./routes/userRoutes'), { prefix: '/user' });
fastify.register(require('./routes/postRoutes'), { prefix: '/posts' });
fastify.register(require('./routes/categoryRoutes'), { prefix: '/categories' });
fastify.register(require('./routes/resourceRoutes'), { prefix: '/resources' });

module.exports = fastify;
