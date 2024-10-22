import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:soul/screens/homescreen.dart';

class Mood3Screen extends StatefulWidget {
  const Mood3Screen({super.key});

  @override
  State<Mood3Screen> createState() => _Mood3ScreenState();
}

class _Mood3ScreenState extends State<Mood3Screen> {
  String selectedTrigger = ""; // Variable to store selected mood

  @override
  void initState() {
    super.initState();
    // Make status bar transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness: Brightness.light, // Light icons
      ),
    );
  }

  // Function to handle mood selection
  void onTriggerSelected(String mood) {
    setState(() {
      selectedTrigger = mood; // Update the selected mood
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend content behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Dark Blur Effect
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/mood_3.jpg'), // Update with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Blur effect
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6), // Darker overlay
                ),
              ),
            ),
          ),
          // Main content - Column with top text and mood buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tray (Black Rectangle)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.3), // Black color with 50% opacity
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "What are Your Top Triggers?", // Updated text
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top:
                                30.0), // Margin to space between text and mood options
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20.0, // Space between buttons
                          runSpacing: 20.0, // Space between rows
                          children: [
                            MoodButton(
                              text: 'Conflict',
                              isSelected: selectedTrigger == 'Conflict',
                              onTriggerSelected: onTriggerSelected,
                            ),
                            MoodButton(
                              text: 'Stress',
                              isSelected: selectedTrigger == 'Stress',
                              onTriggerSelected: onTriggerSelected,
                            ),
                            MoodButton(
                              text: 'Food',
                              isSelected: selectedTrigger == 'Food',
                              onTriggerSelected: onTriggerSelected,
                            ),
                            MoodButton(
                              text: 'Work',
                              isSelected: selectedTrigger == 'Work',
                              onTriggerSelected: onTriggerSelected,
                            ),
                            MoodButton(
                              text: 'Family',
                              isSelected: selectedTrigger == 'Family',
                              onTriggerSelected: onTriggerSelected,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Space outside the rectangle
                // Selected Trigger Display
                if (selectedTrigger.isNotEmpty)
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 35),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Selected: $selectedTrigger',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          // Skip button at the bottom-left corner
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Adds some space from the edges
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen()), // Navigate to HomeScreen
                  );
                },
                icon: const Icon(Icons.arrow_forward,
                    color: Colors.black), // Icon with black color
                label: const Text(
                  "Skip",
                  style:
                      TextStyle(color: Colors.black), // Black text for "Skip"
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4E875), // Custom background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ),
          // Next button at the bottom-right corner
          if (selectedTrigger.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Adds some space from the edges
                child: InkWell(
                  onTap: () {
                    context.go('/home');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7cf6ad), // Custom background color
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold), // Text for "Next"
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            color: Colors.black), // Icon with black color
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Widget for displaying a Mood Button
class MoodButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function(String) onTriggerSelected; // Callback for mood selection

  const MoodButton({
    super.key,
    required this.text,
    this.isSelected = false,
    required this.onTriggerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTriggerSelected(text); // Trigger the callback with the selected mood
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 3, 57, 133)
              : Colors.transparent, // Transparent background for unselected
          border: Border.all(
            color: const Color.fromARGB(255, 130, 127, 127).withOpacity(
                0.5), // Slightly black border for unselected buttons
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
