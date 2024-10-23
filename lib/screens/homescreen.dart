import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soul/models/chat_session.dart';
import 'package:soul/models/user_profile.dart';
import 'package:soul/services/hive_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SoulHomeScreen();
  }
}

class SoulHomeScreen extends StatefulWidget {
  const SoulHomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SoulHomeScreenState createState() => _SoulHomeScreenState();
}

class _SoulHomeScreenState extends State<SoulHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background container (unchanged)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgblue.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // User greeting section (unchanged)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FutureBuilder<UserProfile?>(
                            future: HiveService.getUserProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final userProfile = snapshot.data;
                              final userName = userProfile?.name ?? 'User';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $userName',
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.045,
                                        color: Colors.white,
                                        fontFamily: 'MontserratAlternates'),
                                  ),
                                  Text(
                                    'How can I assist you right now?',
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.02,
                                        color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push('/profile');
                          },
                          child: Hero(
                            tag: "my-hero-animation-tag",
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: screenHeight * 0.04,
                              child: Image.asset("assets/profile.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action buttons (unchanged)
                  HomeActionButtonCards(
                      screenHeight: screenHeight, screenWidth: screenWidth),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Recent History',
                    style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        fontFamily: 'MontserratAlternates'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Recent chat history section
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: FutureBuilder<List<ChatSession>>(
                      future: HiveService.getRecentChatSessions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No recent chat history',
                              style: TextStyle(color: Colors.white));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final session = snapshot.data![index];
                            return _buildRecentHistoryCard(
                              session.title,
                              DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(session.dateTime),
                              () async {
                                await HiveService.deleteChatSession(session.id);
                                setState(() {}); // Refresh the UI
                              },
                              () {
                                context.push('/chat?sessionId=${session.id}');
                              },
                            );
                          },
                        );
                      },
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

  // Helper methods (unchanged)

  Widget _buildRecentHistoryCard(
    String label,
    String date,
    VoidCallback onDelete,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          date,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeActionButtonCards extends StatelessWidget {
  const HomeActionButtonCards({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(16)),
                    color: Color(0xff7cf6ad)),
                height: screenHeight * 0.31,
                width: screenWidth * 0.4,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff75e8a4),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: const Icon(
                        CupertinoIcons.mic,
                        size: 35,
                        color: Color(0xff360844),
                      ),
                    ),
                    const Text(
                      'Talk with SoulVoice',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
              ),
              onTap: () {
                context.push('/voice');
              },
            ),
          ],
        ),
        SizedBox(
          width: screenWidth * 0.01,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(40)),
                    color: Color(0xffbcf489)),
                height: screenHeight * 0.15,
                width: screenWidth * 0.4,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffade07e),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_fill,
                        size: 35,
                        color: Color(0xff512E5F),
                      ),
                    ),
                    const Text(
                      'Chat',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff512E5F),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              ),
              onTap: () {
                context.push('/chat');
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            InkWell(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: Color(0xffe0e5fd)),
                height: screenHeight * 0.15,
                width: screenWidth * 0.4,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 230, 233, 251),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: const Icon(
                        CupertinoIcons.graph_square_fill,
                        size: 35,
                        color: Color(0xff512E5F),
                      ),
                    ),
                    const Text(
                      'Stats',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff512E5F),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              ),
              onTap: () {
                context.push('/stats');
              },
            ),
          ],
        ),
      ],
    );
  }
}
