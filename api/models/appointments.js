const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  doctorName: { type: String, required: true },
  date: { type: String, required: true },
  time: { type: String, required: true },
  patientName: { type: String, required: true },
  patientEmail: { type: String, required: true },
  patientPhone: { type: String, required: true },
  patientUsername: { type: String, required: true }, // Add patientUsername field
});

module.exports = mongoose.model('Appointment', appointmentSchema);