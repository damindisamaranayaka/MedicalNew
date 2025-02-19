const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  fullName: String,
  email: String,
  phoneNumber: String,
  password: String,
  role: String,
  medicalLicenseNumber: String,
  specialization: String,
  yearsOfExperience: Number
});

module.exports = mongoose.model('User', userSchema); // Model for 'users' collection
