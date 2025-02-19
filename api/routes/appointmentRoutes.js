const express = require('express');
const Appointment = require('../models/appointments');

const router = express.Router();

// Book an appointment
router.post('/appointments', async (req, res) => {
  try {
    const { doctorName, date, time, patientName, patientEmail, patientPhone } = req.body;

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
    });

    const savedAppointment = await newAppointment.save();
    res.status(201).json({ message: 'Appointment booked successfully', appointment: savedAppointment });

  } catch (error) {
    res.status(500).json({ message: 'Error saving appointment', error });
  }
});

// Get all appointments
router.get('/appointments', async (req, res) => {
  try {
    const appointments = await Appointment.find();
    res.json(appointments);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving appointments', error });
  }
});

module.exports = router;
