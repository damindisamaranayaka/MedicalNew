import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HealthEducationPage extends StatelessWidget {
  const HealthEducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of Health Education Images
    final List<String> imageUrls = [
      'https://img.freepik.com/free-vector/illustration-people-with-healthy-lifestyle_53876-8768.jpg',
      'https://st.depositphotos.com/2379655/60429/v/450/depositphotos_604293040-stock-illustration-cheerful-little-boy-enjoying-healthy.jpg',
      'https://c8.alamy.com/comp/2GMKFR3/concept-of-health-mind-map-in-handwritten-style-2GMKFR3.jpg',
      'https://media.istockphoto.com/id/1225779547/vector/people-keeping-healthy-diet.jpg?s=612x612&w=0&k=20&c=HDnAlcR98KRV1T4Z4D5-gNvbwRAaT9zzR--JSYgzzfI=',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Education'),
        backgroundColor: const Color.fromARGB(255, 99, 181, 249),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Light blue
              Color(0xFF81D4FA), // Sky blue
              Color(0xFF4FC3F7), // Medium blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Important Tips for a Healthy Life',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Carousel Slider with Shadows & Smooth Borders
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                ),
                items: imageUrls.map((url) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.blue.withOpacity(0.3),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Health Tips Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  '1. Eat a Balanced Diet: Include fruits, vegetables, lean proteins, and whole grains in your meals.\n\n'
                  '2. Stay Hydrated: Drink at least 8 glasses of water daily.\n\n'
                  '3. Exercise Regularly: Aim for 30 minutes of moderate exercise, like walking or cycling, each day.\n\n'
                  '4. Get Adequate Sleep: Ensure 7-8 hours of quality sleep each night.\n\n'
                  '5. Practice Good Hygiene: Wash your hands frequently and maintain oral hygiene by brushing and flossing daily.\n\n'
                  '6. Manage Stress: Practice relaxation techniques like deep breathing, meditation, or yoga.\n\n'
                  '7. Limit Screen Time: Reduce time spent on screens, especially before bed, to improve sleep quality.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
