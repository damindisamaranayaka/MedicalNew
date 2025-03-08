import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String baseUrl = 'http://localhost:3000/api/appointments'; 

  Future<String> bookAppointment(Map<String, dynamic> appointmentData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointmentData),
      );

      if (response.statusCode == 201) {
        return 'Appointment booked successfully!';
      } else {
        final errorResponse = json.decode(response.body);
        if (response.statusCode == 400 && errorResponse['message'] == 'This time slot is already booked.') {
          return 'This time slot is already booked.';
        } else {
          return errorResponse['message'];
        }
      }
    } catch (e) {
      return 'Error booking appointment: $e';
    }
  }

  Future<List<Map<String, dynamic>>> fetchAppointmentsByUsername(String username) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/username/$username'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((appointment) => appointment as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }
}