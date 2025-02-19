// lib/models/patient.dart
class Patient {
  final String id;
  final String name;
  final int age;
  final String contact;
  final String address;
  final String medicalHistory;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.contact,
    required this.address,
    required this.medicalHistory,
  });

  // Factory constructor to create a Patient from JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      contact: json['contact'],
      address: json['address'],
      medicalHistory: json['medicalHistory'],
    );
  }

  // Method to convert a Patient to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'contact': contact,
      'address': address,
      'medicalHistory': medicalHistory,
    };
  }
}
