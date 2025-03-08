import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewBillPage extends StatefulWidget {
  final String username;

  const ViewBillPage({required this.username, Key? key}) : super(key: key);

  @override
  _ViewBillPageState createState() => _ViewBillPageState();
}

class _ViewBillPageState extends State<ViewBillPage> {
  Map<String, dynamic>? bill;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBill();
  }

 Future<void> fetchBill() async {
  try {
    final response = await http.get(
      Uri.parse("http://192.168.220.193:3000/api/bills/username/${widget.username}"),
    );

    print("Raw Response: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print("Decoded Response: $decodedResponse"); // Debugging

      if (decodedResponse is List && decodedResponse.isNotEmpty) {
        setState(() {
          bill = decodedResponse.last;
          isLoading = false;
        });
      } else if (decodedResponse is Map && decodedResponse.containsKey("message")) {
        setState(() {
          errorMessage = decodedResponse["message"]; // Correctly setting error message
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Unexpected response from server.";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = "Error fetching bill. Server responded with status ${response.statusCode}";
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = "Failed to connect to server: $e";
      isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Bill"),
        backgroundColor: const Color(0xFF69B5F7),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF99E0DC), Color(0xFF69B5F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : bill != null
                  ? Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Billing Details",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF69B5F7),
                              ),
                            ),
                            const Divider(thickness: 1, color: Colors.grey),
                            const SizedBox(height: 10),
                            DataTable(
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "Description",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Amount (LKR)",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: [
                                _buildDataRow("Doctor Fee", bill!["doctorFee"]),
                                _buildDataRow("Report Fee", bill!["reportFee"]),
                                _buildDataRow("Clinic Fee", bill!["clinicFee"]),
                                const DataRow(cells: [
                                  DataCell(Divider(thickness: 1, color: Colors.grey)),
                                  DataCell(Divider(thickness: 1, color: Colors.grey)),
                                ]),
                                _buildDataRow(
                                  "Total Fee",
                                  bill!["totalFee"],
                                  isBold: true,
                                  textColor: Colors.red,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF69B5F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                child: Text("Close", style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(String description, dynamic value, {bool isBold = false, Color textColor = Colors.black}) {
    return DataRow(
      cells: [
        DataCell(Text(
          description,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        )),
        DataCell(Text(
          "LKR $value",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        )),
      ],
    );
  }
}
