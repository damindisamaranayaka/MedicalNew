const mongoose = require('mongoose');

const medicineSchema = new mongoose.Schema({
  name: String,
  dosage: String,
  instructions: String
});

const prescriptionSchema = new mongoose.Schema({
  patientName: String,
  patientUsername: String,
  doctorName: String,
  date: String,
  medicines: [medicineSchema]
});

module.exports = mongoose.model('Prescription', prescriptionSchema);
