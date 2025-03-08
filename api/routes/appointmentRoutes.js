const express = require('express');
const Appointment = require('../models/appointments');
const Patient = require('../models/patient');

const router = express.Router();

// Book an appointment
router.post('/appointments', async (req, res) => {
  try {
    const { doctorName, date, time, patientName, patientEmail, patientPhone, patientUsername, patientId } = req.body;

    // Check if the slot is already booked
    const existingAppointment = await Appointment.findOne({ doctorName, date, time });
    if (existingAppointment) {
      return res.status(400).json({ message: 'This time slot is already booked.' });
    }

    // Create and save appointment
    const newAppointment = new Appointment({
      doctorName,
      date,
      time,
      patientName,
      patientEmail,
      patientPhone,
      patientUsername,
      patientId, // Include patientId
    });

    const savedAppointment = await newAppointment.save();
    res.status(201).json({ message: 'Appointment booked successfully', appointment: savedAppointment });

  } catch (error) {
    res.status(500).json({ message: 'Error saving appointment', error });
  }
});

// Fetch appointments by patientUsername
router.get('/appointments/username/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const appointments = await Appointment.find({ patientUsername: username });
    
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving appointments', error });
  }
});

// Define the endpoint to fetch patient info by username
router.get('/patient/username/:username', async (req, res) => {
  try {
    const username = req.params.username;
    const patient = await Patient.findOne({ username: username });

    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    res.status(200).json(patient);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching patient info', error: error.message });
  }
});

module.exports = router;