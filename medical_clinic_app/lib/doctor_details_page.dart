import 'package:flutter/material.dart';
import 'making_the_appointment.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doctorDetails;
  final String patientId;

  const DoctorDetailsPage({super.key, required this.doctorDetails, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Details'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/doctor.png', // Make sure the image path is correct
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Dr. ${doctorDetails['fullName'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Specialization: ${doctorDetails['specialization'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Experience: ${doctorDetails['yearsOfExperience'] ?? 'N/A'} years',
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Available Times:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              doctorDetails['availableTimes'] != null &&
                      doctorDetails['availableTimes'] is Map
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (doctorDetails['availableTimes'] as Map<String, dynamic>)
                          .entries
                          .map((entry) {
                        return Text(
                          '${entry.key}: ${(entry.value as List).join(', ')}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        );
                      }).toList(),
                    )
                  : const Text('N/A', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 20), // Replace Spacer with SizedBox
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakingTheAppointmentPage(
                          doctorDetails: doctorDetails,
                          patientId: patientId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    backgroundColor: const Color.fromARGB(255, 99, 181, 249),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Make an Appointment', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}