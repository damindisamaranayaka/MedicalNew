import 'package:flutter/material.dart';
import 'making_the_appointment.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doctorDetails;

  const DoctorDetailsPage({super.key, required this.doctorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Details'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dr. ${doctorDetails['fullName'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Specialization: ${doctorDetails['specialization'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Experience: ${doctorDetails['yearsOfExperience'] ?? 'N/A'} years',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Available Times:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontSize: 16),
                      );
                    }).toList(),
                  )
                : const Text('N/A', style: TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MakingTheAppointmentPage(
                      doctorDetails: doctorDetails,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color.fromARGB(255, 99, 181, 249),
              ),
              child: const Center(child: Text('Make an Appointment')),
            ),
          ],
        ),
      ),
    );
  }
}


