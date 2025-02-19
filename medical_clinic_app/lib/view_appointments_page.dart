import 'package:flutter/material.dart';

class ViewAppointmentsPage extends StatefulWidget {
  final String patientId;

  const ViewAppointmentsPage({required this.patientId, Key? key})
      : super(key: key);

  @override
  _ViewAppointmentsPageState createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  final List<Map<String, String>> appointments = [
    {'doctorName': 'Dr. John Doe', 'date': '2025-01-10', 'time': '10:00 AM'},
    {'doctorName': 'Dr. Jane Smith', 'date': '2025-01-15', 'time': '2:00 PM'},
    {'doctorName': 'Dr. Emily Clark', 'date': '2025-01-20', 'time': '11:30 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text(
                'No Appointments Found',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: Colors.blue),
                    title: Text('Doctor: ${appointment['doctorName']}'),
                    subtitle: Text(
                        'Date: ${appointment['date']}\nTime: ${appointment['time']}'),
                  ),
                );
              },
            ),
    );
  }
}
