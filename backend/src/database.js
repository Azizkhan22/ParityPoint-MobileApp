const { MongoClient } = require('mongodb');

async function fetchCollectionsAndDocuments() {
  const url = 'mongodb://localhost:27017'; // MongoDB connection string
  const dbName = 'fastifyapp'; // Your database name

  const client = new MongoClient(url, { useUnifiedTopology: true });

  try {
    // Connect to the MongoDB client
    await client.connect();
    console.log("Connected to MongoDB");

    const db = client.db(dbName);

    // Fetch all collections
    const collections = await db.listCollections().toArray();
    console.log(`Collections in ${dbName}:`);
    collections.forEach(collection => {
      console.log(collection.name);
    });

    // Fetch documents from each collection
    for (const collection of collections) {
      const docs = await db.collection(collection.name).find({}).toArray();
      console.log(`Documents in ${collection.name}:`, docs);
    }

  } catch (err) {
    console.error("Error fetching collections or documents:", err);
  } finally {
    // Close the connection
    await client.close();
  }
}

fetchCollectionsAndDocuments();
