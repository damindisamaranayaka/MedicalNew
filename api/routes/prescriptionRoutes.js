const express = require('express');
const Prescription = require('../models/prescription'); // Import the Prescription model

const router = express.Router();

// ✅ Route to get all prescriptions
router.get('/prescriptions', async (req, res) => {
  try {
    const prescriptions = await Prescription.find();
    res.json(prescriptions);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching prescriptions.', error });
  }
});

// ✅ Route to get prescriptions by patientUsername
router.get('/prescriptions/username/:username', async (req, res) => {
  try {
    const { username } = req.params;
    const prescriptions = await Prescription.find({ patientUsername: username });

    if (!prescriptions || prescriptions.length === 0) {
      return res.status(404).json({ message: 'No prescriptions found for this user.' });
    }

    res.json(prescriptions);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching prescriptions.', error });
  }
});

module.exports = router;
