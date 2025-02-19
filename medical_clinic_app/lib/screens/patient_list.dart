// lib/screens/patient_list.dart
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/api_service.dart';
import 'add_patient.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  late Future<List<Patient>> futurePatients;

  @override
  void initState() {
    super.initState();
    futurePatients = ApiService.fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: futurePatients,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Patient> patients = snapshot.data!;
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                Patient patient = patients[index];
                return ListTile(
                  title: Text(patient.name),
                  subtitle: Text('Age: ${patient.age}\nContact: ${patient.contact}'),
                  isThreeLine: true,
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load patients'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatient()),
          );
          if (result == true) {
            setState(() {
              futurePatients = ApiService.fetchPatients();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
