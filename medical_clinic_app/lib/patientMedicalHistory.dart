import 'package:flutter/material.dart';
import 'package:medical_clinic_app/services/patient_service.dart';

class PatientMedicalHistory extends StatefulWidget {
  final String patientId; // Pass the patient ID
  const PatientMedicalHistory({super.key, required this.patientId});

  @override
  _PatientMedicalHistoryState createState() => _PatientMedicalHistoryState();
}

class _PatientMedicalHistoryState extends State<PatientMedicalHistory> {
  final TextEditingController _drugAllergiesController = TextEditingController();
  final TextEditingController _otherIllnessesController = TextEditingController();
  final TextEditingController _currentMedicationsController = TextEditingController();
  
  final List<String> _conditions = [
    'High Blood Pressure',
    'Cancer',
    'Heart Attack',
    'Kidney Disease',
    'Lung Disease'
  ];

  final List<bool> _selectedConditions = List.generate(5, (index) => false);
  
  final PatientService _patientService = PatientService();

  Future<void> _saveMedicalHistory() async {
    final allergies = _drugAllergiesController.text.trim();
    final illnesses = _otherIllnessesController.text.trim();
    final medications = _currentMedicationsController.text.trim();
    final selectedConditions = _conditions
        .asMap()
        .entries
        .where((entry) => _selectedConditions[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (allergies.isEmpty && illnesses.isEmpty && medications.isEmpty && selectedConditions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in at least one field.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final medicalHistory = {
      "drugAllergies": allergies,
      "conditions": selectedConditions,
      "otherIllnesses": illnesses,
      "currentMedications": medications,
    };

    bool isSaved = await _patientService.saveMedicalHistory(widget.patientId, medicalHistory);

    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medical history saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save medical history.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Medical History'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/doctor.png',  // Make sure the image path is correct
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Patient Medical History",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please list any drug allergies:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField(_drugAllergiesController, "Enter allergies"),
              const SizedBox(height: 20),
              const Text(
                "Have you ever had (Please check all that apply):",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: _conditions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final condition = entry.value;
                  return CheckboxListTile(
                    title: Text(condition),
                    value: _selectedConditions[index],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedConditions[index] = value;
                        });
                      }
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                "Other illnesses:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField(_otherIllnessesController, "Enter other illnesses"),
              const SizedBox(height: 20),
              const Text(
                "Please list your Current Medications:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTextField(_currentMedicationsController, "Enter medications"),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveMedicalHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        filled: true,
        fillColor: Colors.white70,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
