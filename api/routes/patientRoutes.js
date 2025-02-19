const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Patient = require('../models/patient'); // Import the Patient model
const router = express.Router();

// Middleware to verify JWT tokens
const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.sendStatus(401); // Unauthorized

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403); // Forbidden
    req.user = user; // Save user info for use in other routes
    next();
  });
};

// Registration endpoint
router.post('/register', async (req, res) => {
  const { fullname, gender, phone, email, nic, address, username, password } = req.body;

  // Validate the request body
  if (!fullname || !gender || !phone || !email || !nic || !address || !username || !password) {
    return res.status(400).send('All fields are required');
  }

  // Validate phone number (must be exactly 10 digits)
  const phoneRegex = /^\d{10}$/;
  if (!phoneRegex.test(phone)) {
    return res.status(400).send('Phone number must be exactly 10 digits');
  }

  // Validate NIC (must be a string with a maximum length of 12 characters)
  if (nic.length > 12) {
    return res.status(400).send('NIC must be less than 13 characters');
  }

  // Check if the username already exists
  try {
    const existingPatient = await Patient.findOne({ username });
    if (existingPatient) {
      return res.status(400).send('Username already exists');
    }

    // Create a new patient
    const newPatient = new Patient({
      fullname,
      gender,
      phone,
      email,
      nic,
      address,
      username,
      password, // Password will be hashed in the patient model's pre-save hook
    });

    // Hash the password before saving
    newPatient.password = await bcrypt.hash(password, 10);

    await newPatient.save();
    res.status(201).send('Patient registered successfully');
  } catch (error) {
    console.error('Error during registration:', error);
    res.status(500).send('Error registering patient: ' + error.message);
  }
});

// Login endpoint
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Find the patient by username
    const patient = await Patient.findOne({ username });
    if (!patient) {
      return res.status(400).send('Invalid username or password.');
    }

    // Validate the password
    const validPassword = await bcrypt.compare(password, patient.password);
    if (!validPassword) {
      return res.status(400).send('Invalid username or password.');
    }

    // Generate a JWT token
    const token = jwt.sign({ _id: patient._id }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });

    // Send the token back to the client
    res.json({ token, patientId: patient._id });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).send('Server error');
  }
});

// Endpoint to update General Patient Information
router.post('/patient/:id/general-info', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { gender, birthDate, height, weight, reasonForVisit } = req.body;

  try {
    // Find patient by ID
    const patient = await Patient.findById(id);

    if (!patient) {
      return res.status(404).send('Patient not found');
    }

    // Update generalInfo field
    patient.generalInfo = {
      gender: gender || patient.generalInfo.gender,
      birthDate: birthDate || patient.generalInfo.birthDate,
      height: height || patient.generalInfo.height,
      weight: weight || patient.generalInfo.weight,
      reasonForVisit: reasonForVisit || patient.generalInfo.reasonForVisit,
    };

    await patient.save();
    res.status(200).send('General patient information updated successfully');
  } catch (error) {
    console.error('Error updating general patient information:', error);
    res.status(500).send('Server error: ' + error.message);
  }
});

// POST /api/patient/general-info
router.post('/general-info', async (req, res) => {
  const { id, gender, birthDate, height, weight, reasonForVisit } = req.body;

  try {
    // Fetch the patient using the provided id
    const patient = await Patient.findById(id);
    if (!patient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    // Update the patient's generalInfo field
    patient.generalInfo = {
      gender,
      birthDate,
      height,
      weight,
      reasonForVisit,
    };

    // Save the updated patient record
    await patient.save();
    res.status(200).json({ message: 'Patient information saved successfully!' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error saving patient information' });
  }
});


// Endpoint to update Patient Medical History
router.post('/patient/:id/medical-history', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { drugAllergies, otherIllnesses, currentMedications, conditions } = req.body;

  try {
    // Find the patient by ID
    const patient = await Patient.findById(id);
    if (!patient) {
      return res.status(404).send('Patient not found');
    }

    // Update the patient's medicalHistory field
    patient.medicalHistory = {
      drugAllergies: drugAllergies || patient.medicalHistory.drugAllergies,
      otherIllnesses: otherIllnesses || patient.medicalHistory.otherIllnesses,
      currentMedications: currentMedications || patient.medicalHistory.currentMedications,
      conditions: conditions || patient.medicalHistory.conditions,
    };

    // Save the updated patient document
    await patient.save();
    res.status(200).send('Patient medical history updated successfully');
  } catch (error) {
    console.error('Error updating medical history:', error);
    res.status(500).send('Server error: ' + error.message);
  }
});

// Example fetch from frontend: POST /api/patient/:id/medical-history
// Body:
// {
//   "drugAllergies": "Peanuts",
//   "otherIllnesses": "Diabetes",
//   "currentMedications": "Insulin",
//   "conditions": ["High Blood Pressure", "Kidney Disease"]
// }


// Fetch patient profile by ID
router.get('/patient/:id', authenticateToken, async (req, res) => {
  const { id } = req.params;

  try {
    const patient = await Patient.findById(id).select('-password'); // Exclude the password field
    if (!patient) {
      return res.status(404).send('Patient not found');
    }
    res.status(200).json(patient); // Return patient data
  } catch (error) {
    console.error('Error fetching patient profile:', error);
    res.status(500).send('Server error: ' + error.message);
  }
});

module.exports = router;