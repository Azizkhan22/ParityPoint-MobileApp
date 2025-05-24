const app = require('./app');
const PORT = process.env.PORT || 3000;

const start = async () => {
  try {
    await app.listen({ port: PORT });
    app.log.info(`Server running at http://localhost:${PORT}`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
