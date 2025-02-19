import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medical_clinic_app/services/token_storage.dart';

class PatientService {
  final String _baseUrl = "http://localhost:3000/api"; // Replace with your API base URL

  // Fetch patient profile by ID
  Future<Map<String, dynamic>?> fetchPatientProfile(String patientId) async {
    final token = await getToken(); // Retrieve the JWT token
    if (token == null) {
      print('User is not logged in. Please log in to continue.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/patient/$patientId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return patient data as a map
      } else {
        print("Failed to fetch patient profile: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error fetching patient profile: $error");
      return null;
    }
  }

  // Save patient general information
  Future<bool> savePatientInfo(Map<String, dynamic> patientData) async {
    final token = await getToken(); // Retrieve the JWT token
    if (token == null) {
      print('User is not logged in. Please log in to continue.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/patient/${patientData["id"]}/general-info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(patientData),
      );

      if (response.statusCode == 200) {
        print('Patient information saved successfully!');
        return true;
      } else {
        print('Failed to save patient info. Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred while saving patient info: $e');
      return false;
    }
  }

  // Save patient medical history
  Future<bool> saveMedicalHistory(String patientId, Map<String, dynamic> medicalHistory) async {
    final token = await getToken(); // Retrieve the JWT token
    if (token == null) {
      print('User is not logged in. Please log in to continue.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/patient/$patientId/medical-history"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(medicalHistory),
      );

      if (response.statusCode == 200) {
        print('Medical history saved successfully!');
        return true;
      } else {
        print("Failed to save medical history: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error saving medical history: $error");
      return false;
    }
  }

  // Delete patient record
  Future<bool> deletePatient(String patientId) async {
    final token = await getToken(); // Retrieve the JWT token
    if (token == null) {
      print('User is not logged in. Please log in to continue.');
      return false;
    }

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/patient/$patientId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print('Patient record deleted successfully!');
        return true;
      } else {
        print("Failed to delete patient record: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error deleting patient record: $error");
      return false;
    }
  }

  // Fetch all patients (for admin or staff use)
  Future<List<Map<String, dynamic>>?> fetchAllPatients() async {
    final token = await getToken(); // Retrieve the JWT token
    if (token == null) {
      print('User is not logged in. Please log in to continue.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/patients"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        print("Failed to fetch patients: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error fetching patients: $error");
      return null;
    }
  }
}
