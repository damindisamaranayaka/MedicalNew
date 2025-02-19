const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema({
 fullname: String,
  gender: String,
  phone: String,
  email: String,
  nic: String,
  address: String,
  username: String,
  password: String, 

  // General Patient Information
  generalInfo: {
    gender: { type: String, required: false },
    birthDate: { type: String, required: false, validate: /^\d{4}-\d{2}-\d{2}$/ },
    height: { type: Number, required: false }, // Height in cm
    weight: { type: Number, required: false }, // Weight in kg
    reasonForVisit: { type: String, required: false },
  },

  // New Field: Patient Medical History
  medicalHistory: {
    drugAllergies: { type: String, default: '' }, // Free text
    otherIllnesses: { type: String, default: '' }, // Free text
    currentMedications: { type: String, default: '' }, // Free text
    conditions: [{ type: String }], // Array of predefined conditions
  },
});

module.exports = mongoose.model('Patient', patientSchema);
