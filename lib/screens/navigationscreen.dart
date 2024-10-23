import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SoulBotHome extends StatefulWidget {
  final Widget child; // Child widget to show the routed screen
  const SoulBotHome({super.key, required this.child});

  @override
  State<SoulBotHome> createState() => _SoulBotHomeState();
}

class _SoulBotHomeState extends State<SoulBotHome> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, // Display the current page
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
            icon: Icon(
              CupertinoIcons.home,
              color: currentPageIndex == 0
                  ? const Color(0xff032429)
                  : Colors.white,
            ),
            title: "Home",
          ),
          TabItem(
            icon: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: currentPageIndex == 1
                  ? const Color(0xff032429)
                  : Colors.white,
            ),
            title: "SoulBot",
          ),
          TabItem(
            icon: Icon(
              CupertinoIcons.pencil_outline,
              color: currentPageIndex == 2
                  ? const Color(0xff032429)
                  : Colors.white,
            ),
            title: "Moods",
          ),
          TabItem(
            icon: Icon(
              CupertinoIcons.music_mic,
              color: currentPageIndex == 3
                  ? const Color(0xff032429)
                  : Colors.white,
            ),
            title: "Voice",
          ),
          TabItem(
            icon: Icon(
              CupertinoIcons.chart_pie_fill,
              color: currentPageIndex == 4
                  ? const Color(0xff032429)
                  : Colors.white,
            ),
            title: "Stats",
          ),
        ],
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/chat');
              break;
            case 2:
              context.go('/moods');
              break;
            case 3:
              context.go('/voice');
              break;
            case 4:
              context.go('/stats');
              break;
          }
        },
        shadowColor: const Color.fromARGB(255, 14, 14, 14),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
