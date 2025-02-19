const express = require("express");
const Bill = require("../models/bills");

const router = express.Router();

// Get all bills
router.get("/bills", async (req, res) => {
  try {
    const bills = await Bill.find();
    res.status(200).json(bills);
  } catch (error) {
    res.status(500).json({ message: "Failed to retrieve bills", error: error.message });
  }
});

router.get("/bills/username/:username", async (req, res) => {
  try {
    const bills = await Bill.find({ username: req.params.username });
    if (bills.length === 0) {
      return res.status(200).json({ message: "No bills found for this user" });
    }
    res.status(200).json(bills);
  } catch (error) {
    res.status(500).json({ message: "Failed to retrieve bill", error: error.message });
  }
});

// Add a new bill (Optional)
router.post("/bills", async (req, res) => {
  try {
    const { patientName, username,doctorFee, reportFee, clinicFee, totalFee } = req.body;

    const newBill = new Bill({
      patientName,
      username,
      doctorFee,
      reportFee,
      clinicFee,
      totalFee,
    });

    await newBill.save();
    res.status(201).json(newBill);
  } catch (error) {
    res.status(500).json({ message: "Failed to add bill", error: error.message });
  }
});

module.exports = router;
