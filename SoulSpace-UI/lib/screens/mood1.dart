import 'dart:ui'; // Import for ImageFilter.blur
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // To manage status bar settings
import 'package:soul/screens/mood2.dart';

class Mood1Screen extends StatefulWidget {
  const Mood1Screen({super.key});

  @override
  Mood1ScreenState createState() => Mood1ScreenState();
}

class Mood1ScreenState extends State<Mood1Screen> {
  String selectedMood = '😊 Happy'; // Default mood with both emoji and label

  final List<String> moods = [
    '--select--',
    '😊 Happy',
    '😢 Sad',
    '😠 Angry',
    '😌 Relieved',
    '😂 Laughing',
    '😭 Crying',
    '😰 Anxious',
    '😡 Enraged',
    '😐 Neutral',
    '😫 Tired',
    '😨 Fearful',
    '😤 Frustrated',
  ];

  @override
  void initState() {
    super.initState();
    // Set the status bar to be transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0, // Remove shadow under the AppBar
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chevron_back),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          // Full-page Background Image with Dark Blur Effect
          Container(
            width: MediaQuery.of(context).size.width, // Full width
            height: MediaQuery.of(context).size.height, // Full height
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/mood_1.jpg'), // Replace with your image asset
                fit: BoxFit.cover, // Cover the full page
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5.0, sigmaY: 5.0), // Increase blur intensity
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6), // Darker overlay
                  backgroundBlendMode: BlendMode.darken, // Darken blend mode
                ),
              ),
            ),
          ),

          // Centered content without animation
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.3), // Black color with 40% opacity
                borderRadius: BorderRadius.circular(20), // Rounded corners
                border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1), // Border for glass effect
              ),
              padding:
                  const EdgeInsets.all(20.0), // Padding inside the black tray
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Margin to provide space on the sides
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize height to content
                children: [
                  const Text(
                    "How are you feeling today?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: 22), // Space between the text and dropdown

                  // Dropdown menu for mood selection
                  DropdownButton<String>(
                    value: selectedMood,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(20)), // Rounded corners
                    dropdownColor: Colors.black
                        .withOpacity(0.5), // Background color of dropdown
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500, // Improved font style
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white, // Custom icon color
                      size: 26, // Larger icon size
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.white, // Custom underline color
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMood = newValue!;
                      });
                    },
                    items: moods.map<DropdownMenuItem<String>>((String mood) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.center, // Centered text
                        value: mood,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0), // Padding inside dropdown
                          child: Text(
                            mood,
                            style: const TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 18, // Text size
                              fontWeight: FontWeight
                                  .bold, // Bold text for better appearance
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Skip button at the bottom-left corner
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Adds some space from the edges
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const Mood2Screen(), // Navigate to Mood2Screen
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4E875), // Custom background color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward,
                          color: Colors.black), // Icon with black color
                      SizedBox(width: 8),
                      Text(
                        "Skip",
                        style: TextStyle(
                            color: Colors.black), // Black text for "Skip"
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Next button at the bottom-right corner
          if (selectedMood != '--select--')
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(
                    16.0), // Adds some space from the edges
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Mood2Screen(), // Navigate to Mood2Screen
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7cf6ad), // Custom background color
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward,
                            color: Colors.black), // Icon with black color
                        SizedBox(width: 8),
                        Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.black), // Black text for "Next"
                        ),
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
