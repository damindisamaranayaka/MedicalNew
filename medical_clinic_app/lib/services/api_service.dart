// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';

class ApiService {
  // Replace with your backend URL
  static const String baseUrl = 'http://localhost:3000';

  // Fetch all patients
  static Future<List<Patient>> fetchPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Patient> patients = body.map((dynamic item) => Patient.fromJson(item)).toList();
      return patients;
    } else {
      throw Exception('Failed to load patients');
    }
  }

  // Add a new patient
  static Future<bool> addPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // Similarly, you can add methods for updating and deleting patients
}
