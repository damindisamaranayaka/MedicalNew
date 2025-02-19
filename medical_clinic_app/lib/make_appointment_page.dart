import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'doctor_details_page.dart';

class MakeAppointmentPage extends StatefulWidget {
  const MakeAppointmentPage({super.key});

  @override
  State<MakeAppointmentPage> createState() => _MakeAppointmentPageState();
}

class _MakeAppointmentPageState extends State<MakeAppointmentPage> {
  late Future<List<Map<String, dynamic>>> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    const String apiUrl = 'http://localhost:3000/api/doctor'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make an Appointment'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No doctors found.',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(
                      doctor['fullName'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(doctor['specialization'] ?? 'Not specified'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailsPage(
                              doctorDetails: doctor,
                            ),
                          ),
                        );
                      },
                      child: const Text('Check'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
