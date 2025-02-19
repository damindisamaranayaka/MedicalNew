import 'package:flutter/material.dart';
import 'package:medical_clinic_app/services/appointment_service.dart';

class MakingTheAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;

  const MakingTheAppointmentPage({required this.doctorDetails, Key? key})
      : super(key: key);

  @override
  _MakingTheAppointmentPageState createState() =>
      _MakingTheAppointmentPageState();
}

class _MakingTheAppointmentPageState extends State<MakingTheAppointmentPage> {
  final AppointmentService _appointmentService = AppointmentService();
  String? selectedDate;
  String? selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _patientEmailController = TextEditingController();
  final _patientPhoneController = TextEditingController();

  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      final appointment = {
        'doctorName': 'Dr. ${widget.doctorDetails['fullName']}',
        'date': selectedDate!,
        'time': selectedTime!,
        'patientName': _patientNameController.text,
        'patientEmail': _patientEmailController.text,
        'patientPhone': _patientPhoneController.text,
      };

      bool success = await _appointmentService.bookAppointment(appointment);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error booking appointment. Try again.')),
        );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              const Spacer(),
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
    );
  }
}