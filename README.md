
# ParityPoint

## Project Title and Overview

**ParityPoint** is a platform designed for developers and tech learners to form communities, ask questions, write blogs, and access a centralized hub of resources. The platform enables users to engage with one another, share knowledge, and discover valuable tech insights. It provides a mix of self-uploaded resources and curated references from other websites, offering a dynamic learning and problem-solving experience powered by AI and automation.

This repository is specifically for the **ParityPoint** mobile application code, built using **Flutter** for the frontend and integrated with the **Fastify** backend API.

---

## Tech Stack

### Frontend
- **Flutter**: Framework for building the mobile app.
- **Dart**: Programming language for Flutter.

### Backend
- **Fastify**: High-performance web framework for Node.js.
- **MongoDB**: NoSQL database for storing application data.
- **JWT (JSON Web Tokens)**: For secure authentication.

---

## Project Structure

The project is organized into two main directories to separate the frontend and backend:

```
/ParityPoint
├── /backend               # Fastify API (Backend)
│   ├── /controllers       # Controller files
│   ├── /models            # MongoDB models
│   ├── /routes            # API routes
│   ├── /utils             # Utility functions
│   ├── .env               # Environment variables
│   ├── server.js          # Fastify server setup
│   └── package.json       # Backend dependencies
│
└── /frontend              # Flutter mobile app (Frontend)
    ├── /lib               # Flutter app source code
    ├── /assets            # App assets (images, fonts, etc.)
    ├── pubspec.yaml       # Flutter dependencies
    └── android            # Android-specific files (for building APK)
```

---

## Getting Started

To get the project up and running locally, follow the instructions below to set up both the frontend and backend.

### Clone the repository

```bash
git clone https://github.com/your-username/ParityPoint.git
cd ParityPoint
```

### Install Backend Dependencies

1. Navigate to the `backend` directory:

   ```bash
   cd backend
   ```

2. Install backend dependencies using npm:

   ```bash
   npm install
   ```

3. Create a `.env` file for environment variables, such as MongoDB URI and JWT secret. Example:

   ```
   MONGO_URI=mongodb://localhost:27017/paritypoint
   JWT_SECRET=your_jwt_secret
   ```

4. Start the Fastify server:

   ```bash
   npm start
   ```

   The backend API will now be running on `http://localhost:3000`.

### Install Frontend Dependencies

1. Navigate to the `frontend` directory:

   ```bash
   cd frontend
   ```

2. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

3. Update the `base_api_url` in the Flutter app to match your backend URL (typically in a configuration file or constant):

   ```dart
   String baseApiUrl = "http://localhost:3000";  // Update this URL as needed
   ```

4. Run the Flutter app:

   ```bash
   flutter run
   ```

   The app should now be running on your mobile device or emulator.

---

## Backend Setup

1. **Install Fastify and MongoDB**:

   The backend uses Fastify to handle API requests and MongoDB for data storage. You can set up MongoDB on your local machine or use a cloud service like MongoDB Atlas.

2. **Environment Variables**:

   Create a `.env` file in the backend directory with the following:

   ```
   MONGO_URI=your_mongodb_connection_uri
   JWT_SECRET=your_jwt_secret
   ```

   Replace `your_mongodb_connection_uri` with your actual MongoDB URI and `your_jwt_secret` with a secret key for JWT authentication.

3. **Start the Backend Server**:

   Run the following command to start the Fastify server:

   ```bash
   npm start
   ```

   The server will be available at `http://localhost:3000`.

---

## Frontend Setup

1. **Install Flutter and Dependencies**:

   Make sure you have Flutter installed. You can follow the installation guide on the [Flutter website](https://flutter.dev/docs/get-started/install).

2. **Set API URL**:

   Update the `baseApiUrl` variable in the app code to point to your backend API URL.

3. **Run the Flutter App**:

   Run the following command to start the Flutter app:

   ```bash
   flutter run
   ```

   The app will be available on your mobile device or simulator.

---

## Features (MVP)

- **User Registration**: Users can sign up and log in.
- **User Authentication**: Secure JWT-based authentication.
- **Create Posts**: Users can create posts with text and images.
- **Commenting**: Users can comment on posts.
- **Search**: Users can search for posts and users.
- **User Profiles**: Users have their own profiles displaying their posts and activity.

---

## Contributing

We welcome contributions to ParityPoint! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Write tests if applicable.
4. Submit a pull request with a description of your changes.

Please ensure your code adheres to the project’s coding standards and passes all tests.

---