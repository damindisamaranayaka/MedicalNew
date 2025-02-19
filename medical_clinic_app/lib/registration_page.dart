import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'registration_success_page.dart';
import 'login_page.dart'; // Make sure to import the LoginPage

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  String? _gender;

  final List<String> _genders = ['Male', 'Female'];

  Future<void> _register() async {
    final String fullname = _fullnameController.text;
    final String gender = _gender ?? '';
    final String phone = _phoneController.text;
    final String email = _emailController.text;
    final String nic = _nicController.text;
    final String address = _addressController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    const String url = 'http://localhost:3000/api/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'fullname': fullname,
          'gender': gender,
          'phone': phone,
          'email': email,
          'nic': nic,
          'address': address,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationSuccessPage()),
        );
      } else {
        setState(() => _errorMessage = 'Registration failed: ${response.body}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: const Color(0xFF67C8FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 186, 205, 226),
              Color(0xFF67C8FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Image.asset('assets/doctor.png', width: 100, height: 100),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to CarePlus',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          buildTextField('Full Name', _fullnameController, Icons.person),
                          buildDropdownField(),
                          buildTextField('Phone Number', _phoneController, Icons.phone),
                          buildTextField('Email', _emailController, Icons.email),
                          buildTextField('NIC Number', _nicController, Icons.badge),
                          buildTextField('Address', _addressController, Icons.home),
                          buildTextField('Username', _usernameController, Icons.account_circle),
                          buildPasswordField('Password', _passwordController),
                          buildPasswordField('Confirm Password', _confirmPasswordController),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(_errorMessage!,
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            ),
                            child: const Text('Register', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _gender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        items: _genders.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() => _gender = value);
        },
      ),
    );
  }
}
