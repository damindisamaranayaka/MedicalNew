import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Add the http package
import 'login_page.dart'; // Import the login page

/*void main() {
  runApp(const MyApp());
}*/
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, 
    home: LoginPage(),
  ));
}
 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Clinic App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), 
    );
  }

  }

  void checkBackendConnection() async {
    
    final url = Uri.parse('http://localhost:3000');  // Backend URL
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Backend Response: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to connect to backend. Status Code: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred: $error');
      }
    }
  }


