import 'dart:ui';

import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/reminder.webp'), // Add your background image here
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Blur effect
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.2), // Slight black overlay with opacity
                ),
              ),
            ),
          ),

          // Main UI with reminders
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70), // Space from the top

                // Title and description
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Daily Reminders',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Set up your daily reminders and make it happen!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Space before reminders list

                // Reminder list
                Expanded(
                  child: ListView(
                    children: [
                      buildReminderRow('08:00', 'Morning'),
                      buildReminderRow('12:00', 'Mid-Day'),
                      buildReminderRow('17:00', 'Evening'),
                      buildReminderRow('20:00', 'Night'),
                    ],
                  ),
                ),

                // Add new reminder button at the bottom
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 215, 153, 228),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text(
                      '+ Add new reminder',
                      style: TextStyle(
                        fontSize: 16, // Reduced font size
                        color:
                            Color.fromARGB(179, 0, 0, 0), // Less intense color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each reminder row
  Widget buildReminderRow(String time, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7), // Black tray background
          borderRadius: BorderRadius.circular(20), // Rounded rectangle
        ),
        child: Row(
          children: [
            // Reminder icon with circle background
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 237, 234, 238),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications,
                  color: Color.fromARGB(255, 64, 8, 74)),
            ),
            const SizedBox(width: 10),
            // Combined rectangle with time and label
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.7), // Black background for time and label
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 221, 158, 216),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Custom switch with light purple active color, aligned properly
            Switch(
              value: true,
              onChanged: (bool value) {},
              activeColor: const Color.fromARGB(255, 64, 9, 74),
              activeTrackColor: const Color.fromARGB(255, 231, 182, 240),
            ),
          ],
        ),
      ),
    );
  }
}
