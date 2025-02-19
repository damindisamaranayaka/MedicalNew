const express = require('express');
const Doctor = require('../models/doctor'); // Import the Doctor model
const router = express.Router();

// Fetch all doctors with full details
router.get('/doctor', async (req, res) => {
  try {
    const doctors = await Doctor.find(
      { role: "Doctor" }, 
      'fullName specialization yearsOfExperience availableDays availableTimes'
    );
    res.status(200).json(doctors);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching doctors', error });
  }
});

// Example route to add a doctor
router.post('/add', async (req, res) => {
  try {
    const { 
      fullName, 
      email, 
      phoneNumber, 
      password, 
      role, 
      medicalLicenseNumber, 
      specialization, 
      yearsOfExperience, 
      availableDays, 
      availableTimes 
    } = req.body;

    // Create a new doctor instance
    const doctor = new Doctor({
      fullName,
      email,
      phoneNumber,
      password,
      role: role || 'Doctor', // Default role to "Doctor" if not provided
      medicalLicenseNumber,
      specialization,
      yearsOfExperience,
      availableDays,
      availableTimes,
    });

    // Save the doctor to the database
    const savedDoctor = await doctor.save();

    res.status(201).json(savedDoctor);
  } catch (error) {
    res.status(500).json({ message: 'Error adding doctor', error }); // Handle errors
  }
});

module.exports = router;