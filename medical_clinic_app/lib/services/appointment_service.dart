import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentService {
  static const String baseUrl = 'http://localhost:3000/api/appointments'; // For Android Emulator use 10.0.2.2

  Future<bool> bookAppointment(Map<String, dynamic> appointmentData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointmentData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
