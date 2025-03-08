const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
require('dotenv').config();

const patientRoutes = require('./routes/patientRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const appointmentRoutes = require('./routes/appointmentRoutes'); // Import appointment routes
const billRoutes = require("./routes/billRoutes"); // Import bill routes
const prescriptionRoutes = require("./routes/prescriptionRoutes");
const app = express();

// Import database connection
require('./db');

// CORS configuration
const corsOptions = {
  origin: '*', // Allow all origins (for testing), or specify the allowed frontend URL
  methods: 'GET,POST,PUT,DELETE',
  allowedHeaders: 'Content-Type, Authorization',
};

app.use(cors(corsOptions));  // Use the updated CORS configuration

// Middleware
app.use(express.json());

// Token verification middleware
const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.sendStatus(401);

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

// Use routes
app.use('/api', patientRoutes);
app.use('/api', doctorRoutes);
app.use('/api', appointmentRoutes); // API endpoint for appointments
app.use("/api", billRoutes); // API endpoint for bills
app.use("/api", prescriptionRoutes);

// Default route
app.get('/', (req, res) => {
  res.send('Welcome to the Medical Clinic API');
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
