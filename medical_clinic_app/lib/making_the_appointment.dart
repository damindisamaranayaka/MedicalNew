import 'package:flutter/material.dart';
import 'package:medical_clinic_app/services/appointment_service.dart';
import 'package:medical_clinic_app/services/patient_service.dart'; // Import the PatientService to fetch patient info

class MakingTheAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;
  final String patientId; // Add patientId field

  const MakingTheAppointmentPage({required this.doctorDetails, required this.patientId, Key? key})
      : super(key: key);

  @override
  _MakingTheAppointmentPageState createState() =>
      _MakingTheAppointmentPageState();
}

class _MakingTheAppointmentPageState extends State<MakingTheAppointmentPage> {
  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService(); // Instance of PatientService to fetch patient info
  String? selectedDate;
  String? selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _patientUsernameController = TextEditingController(); // Controller for the username field
  final _patientNameController = TextEditingController();
  final _patientEmailController = TextEditingController();
  final _patientPhoneController = TextEditingController();

  Future<void> _fetchPatientInfo() async {
    final username = _patientUsernameController.text;
    try {
      final patientInfo = await _patientService.fetchPatientInfo(username);
      if (patientInfo != null) {
        setState(() {
          _patientNameController.text = patientInfo['fullname'];
          _patientEmailController.text = patientInfo['email'];
          _patientPhoneController.text = patientInfo['phone'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient information not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching patient information: $e')),
      );
    }
  }

  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      final appointment = {
        'doctorName': 'Dr. ${widget.doctorDetails['fullName']}',
        'date': selectedDate!,
        'time': selectedTime!,
        'patientName': _patientNameController.text,
        'patientEmail': _patientEmailController.text,
        'patientPhone': _patientPhoneController.text,
        'patientUsername': _patientUsernameController.text, // Include the username
        'patientId': widget.patientId, // Include the patient ID
      };

      final result = await _appointmentService.bookAppointment(appointment);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      if (result == 'Appointment booked successfully!') {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = widget.doctorDetails['availableTimes'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make an Appointment'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 186, 205, 226), Color(0xFF67C8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${widget.doctorDetails['fullName'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select a Date:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDate,
                      items: availableTimes != null
                          ? availableTimes.keys
                              .map((day) => DropdownMenuItem<String>(
                                    value: day,
                                    child: Text(day),
                                  ))
                              .toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          selectedDate = value;
                          selectedTime = null; // Reset time when date changes
                        });
                      },
                      validator: (value) => value == null ? 'Please select a date' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select a Time:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedTime,
                      items: (selectedDate != null &&
                              availableTimes != null &&
                              availableTimes[selectedDate] != null)
                          ? (availableTimes[selectedDate] as List)
                              .map((time) => DropdownMenuItem<String>(
                                    value: time,
                                    child: Text(time),
                                  ))
                              .toList()
                          : [],
                      onChanged: (value) {
                        setState(() {
                          selectedTime = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a time' : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _patientUsernameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your username' : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchPatientInfo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
                      ),
                      child: const Text('Press Enter to get Patient Information'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _patientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _patientEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Your Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _patientPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Your Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitAppointment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
                      ),
                      child: const Center(child: Text('Confirm Appointment')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}