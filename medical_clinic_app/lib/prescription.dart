import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrescriptionPage extends StatefulWidget {
  final String patientUsername;

  const PrescriptionPage({required this.patientUsername, Key? key}) : super(key: key);

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  List<dynamic> prescriptions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    final String apiUrl = "http://localhost:3000/api/prescriptions/username/${widget.patientUsername}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          prescriptions = jsonDecode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = "No prescriptions found.";
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load prescriptions');
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
        isLoading = false;
      });
      print('Error fetching prescriptions: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        centerTitle: true,
        backgroundColor:  const Color(0xFF69B5F7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: prescriptions.length,
                    itemBuilder: (context, index) {
                      final prescription = prescriptions[index];

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
                                title: Text(
                                  "Doctor: ${prescription['doctorName']}",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Date: ${prescription['date']}",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ),
                              const Divider(),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 4),
                                child: Text("Medicines:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (prescription['medicines'] as List).map((medicine) {
                                  return ListTile(
                                    leading: const Icon(Icons.medication, color: Colors.blueAccent),
                                    title: Text("${medicine['name']} (${medicine['dosage']})"),
                                    subtitle: Text("Instructions: ${medicine['instructions']}"),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
