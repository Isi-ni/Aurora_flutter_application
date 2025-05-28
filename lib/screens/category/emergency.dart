import 'package:flutter/material.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final List<Map<String, String>> emergencyContacts = [
    {'country': 'United States', 'hotline': '988'},
    {'country': 'United Kingdom', 'hotline': '116 123'},
    {'country': 'Canada', 'hotline': '988'},
    {'country': 'Australia', 'hotline': '13 11 14'},
    {'country': 'Germany', 'hotline': '0800 111 0 111'},
    // You can add more countries here...
  ];

  String? selectedCountry;
  String? selectedHotline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/emergency_bg.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          // Main UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency Mental Health Hotlines',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown to search/select country
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Select your country',
                    ),
                    value: selectedCountry,
                    items: emergencyContacts.map((contact) {
                      return DropdownMenuItem<String>(
                        value: contact['country'],
                        child: Text(contact['country']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                        selectedHotline = emergencyContacts.firstWhere(
                          (contact) => contact['country'] == value,
                        )['hotline'];
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Show hotline if selected
                  if (selectedHotline != null)
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      child: ListTile(
                        leading: Icon(Icons.phone, color: Colors.red),
                        title: Text(
                          '$selectedCountry Helpline',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Call: $selectedHotline'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
