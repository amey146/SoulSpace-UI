import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soul/models/user_profile.dart';
import 'package:soul/services/hive_service.dart';
import 'package:soul/screens/profile_edit.dart';
import 'package:soul/screens/question.dart';
import 'package:soul/screens/reminder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isGoldMember = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: HiveService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final userProfile = snapshot.data;
        if (userProfile == null) {
          return const Center(child: Text('No profile data available'));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade700,
            title: const Text("Profile"),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xff661080), Color(0xff2B0437)])),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Hero(
                        tag: "my-hero-animation-tag",
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userProfile.name,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      isGoldMember
                          ? const Text(
                              "⚡ Gold Member",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : const Text(
                              "Upgrade to Gold?",
                              style: TextStyle(color: Colors.white70),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userProfile.phoneNumber,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mail",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userProfile.email,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/mood1');
                        },
                        child: buildSettingItem(
                          icon: Icons.person_outline,
                          title: "😊Mood Entry😰",
                          trailing: const Icon(CupertinoIcons.gauge),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Questions(),
                            ),
                          );
                        },
                        child: buildSettingItem(
                          icon: CupertinoIcons.question_circle,
                          title: "Questionnaire",
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        child: buildSettingItem(
                          icon: Icons.person_outline,
                          title: "Profile Edit",
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReminderScreen(),
                            ),
                          );
                        },
                        child: buildSettingItem(
                          icon: Icons.settings,
                          title: "Settings & Reminders",
                          trailing: const Icon(CupertinoIcons.chevron_right),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
