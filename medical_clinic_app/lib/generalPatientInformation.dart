import 'package:flutter/material.dart';
import 'package:medical_clinic_app/services/patient_service.dart';
import 'patientMedicalHistory.dart';

class GeneralPatientInformation extends StatefulWidget {
  final String patientId;

  const GeneralPatientInformation({super.key, required this.patientId});

  @override
  _GeneralPatientInformationState createState() =>
      _GeneralPatientInformationState();
}

class _GeneralPatientInformationState
    extends State<GeneralPatientInformation> {
  String? _selectedGender;
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final PatientService _patientService = PatientService();

  // Save patient info
  Future<void> _savePatientInfo() async {
    // Validate form inputs
    if (_selectedGender == null ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Construct birthDate as YYYY-MM-DD
    final String year = _yearController.text.trim();
    final String month = _monthController.text.padLeft(2, '0').trim();
    final String day = _dayController.text.padLeft(2, '0').trim();
    final String birthDate = "$year-$month-$day";

    // Validate birthDate format (basic YYYY-MM-DD validation)
    final RegExp dateRegex = RegExp(r"^\d{4}-\d{2}-\d{2}$");
    if (!dateRegex.hasMatch(birthDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid birth date format. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final patientData = {
      "id": widget.patientId, // Use dynamically passed patient ID
      "gender": _selectedGender,
      "birthDate": birthDate,
      "height": double.tryParse(_heightController.text),
      "weight": double.tryParse(_weightController.text),
      "reasonForVisit": _reasonController.text,
    };

    // Attempt to save data through the service
    bool isSaved = await _patientService.savePatientInfo(patientData);
    if (isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient information saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientMedicalHistory(patientId: widget.patientId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save patient information."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Patient Information'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent,
              Colors.white,
            ],
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
                  "General Patient Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Gender:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedGender,
                hint: const Text('Select Gender'),
                isExpanded: true,
                items: ['Male', 'Female'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "Patient Birth Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _monthController,
                      hintText: "Month",
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _dayController,
                      hintText: "Day",
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: _yearController,
                      hintText: "Year",
                      icon: Icons.calendar_today,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _heightController,
                labelText: "Patient Height (cm's)",
                icon: Icons.height,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _weightController,
                labelText: "Patient Weight (Kg's)",
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 15),
              const Text(
                "Reason for seeing the doctor:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _reasonController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter details",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _savePatientInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? labelText,
    String? hintText,
    TextEditingController? controller,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
