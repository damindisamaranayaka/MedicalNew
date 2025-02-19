import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_clinic_app/services/patient_service.dart';

class ViewProfile extends StatefulWidget {
  final String userId; // Pass the userId from Login or HomePage

  const ViewProfile({super.key, required this.userId});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final service = PatientService();
    final profile = await service.fetchPatientProfile(widget.userId); // Fetch user profile data
    setState(() {
      userProfile = profile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Profile"),
        backgroundColor: const Color(0xFF67C8FF),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 186, 205, 226), Color(0xFF67C8FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userProfile != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Profile Picture
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: Icon(FontAwesomeIcons.user, size: 50, color: Colors.blueAccent),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Profile Details Sections
                          _buildProfileCard("Basic Information", FontAwesomeIcons.user, [
                            _buildProfileRow("Full Name:", userProfile?['fullname']),
                            _buildProfileRow("Gender:", userProfile?['gender']),
                            _buildProfileRow("Phone Number:", userProfile?['phone']),
                            _buildProfileRow("Email:", userProfile?['email']),
                            _buildProfileRow("Address:", userProfile?['address']),
                          ]),

                          _buildProfileCard("General Information", FontAwesomeIcons.infoCircle, [
                            _buildProfileRow("Birth Date:", userProfile?['generalInfo']?['birthDate']),
                            _buildProfileRow("Height:", "${userProfile?['generalInfo']?['height']} cm"),
                            _buildProfileRow("Weight:", "${userProfile?['generalInfo']?['weight']} kg"),
                            _buildProfileRow("Reason for Visit:", userProfile?['generalInfo']?['reasonForVisit']),
                          ]),

                          _buildProfileCard("Medical History", FontAwesomeIcons.hospitalUser, [
                            _buildProfileRow("Drug Allergies:", userProfile?['medicalHistory']?['drugAllergies']),
                            _buildProfileRow("Other Illnesses:", userProfile?['medicalHistory']?['otherIllnesses']),
                            _buildProfileRow("Current Medications:", userProfile?['medicalHistory']?['currentMedications']),
                            _buildProfileRow(
                              "Conditions:",
                              (userProfile?['medicalHistory']?['conditions'] as List<dynamic>?)
                                      ?.join(', ') ??
                                  "N/A",
                            ),
                          ]),

                          const SizedBox(height: 20),

                          // Back Button
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                            label: const Text("Back to Home", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text("Failed to load profile. Please try again."),
                  ),
      ),
    );
  }

  // Profile Card Section with Icons
  Widget _buildProfileCard(String title, IconData icon, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const Divider(thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  // Profile Detail Row
  Widget _buildProfileRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value ?? "N/A",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
