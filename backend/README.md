# Fastify Backend for Flutter App

This is a Fastify backend API with MongoDB for a Flutter app.

## Features
- User registration with email verification
- JWT login and auth middleware
- CRUD APIs for Users, Posts, Categories, Resources
- Nodemailer email confirmation
- MongoDB + Mongoose ODM

## Setup
1. Clone or unzip
2. Run `npm install`
3. Set environment variables in `.env`
4. Run `npm run dev` or `npm start`
5. Connect your Flutter app to API endpoints

## Environment Variables
See `.env` file for variables like MONGO_URI, SMTP settings, JWT secret.

## API Endpoints
- POST `/auth/register` — Register user (send email confirmation)
- GET `/auth/verify-email?token=...` — Verify email
- POST `/auth/login` — Login and get JWT token
- GET `/user/profile` — Get logged-in user profile (auth required)
- CRUD endpoints for `/posts`, `/categories`, `/resources`

## License
MIT
