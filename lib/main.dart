import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soul/screens/homescreen.dart';
import 'package:soul/screens/mood1.dart';
import 'package:soul/screens/navigationscreen.dart';
import 'package:soul/screens/profile_view.dart';
import 'package:soul/screens/soulspace.dart';
import 'package:soul/screens/soulvoice_view.dart';
import 'package:soul/screens/statsscreen.dart';
import 'package:soul/services/hive_service.dart';
import 'package:soul/screens/login.dart';
import 'package:soul/screens/signup.dart';
import 'package:soul/screens/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await HiveService.initChatSessions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/questionnaire',
        builder: (context, state) => const Questions(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) {
          return SoulBotHome(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const SoulHomeScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) {
              final sessionId = state.queryParams['sessionId'];
              return ChatScreen(sessionId: sessionId);
            },
          ),
          GoRoute(
            path: '/moods',
            builder: (context, state) => const Mood1Screen(),
          ),
          GoRoute(
            path: '/voice',
            builder: (context, state) => const SoulVoiceView(),
          ),
          GoRoute(
            path: '/stats',
            builder: (context, state) => const Statsscreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.activeBlue,
        fontFamily: 'MontserratAlternates',
      ),
      routerConfig: _router,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating splash screen delay
    final isLoggedIn = await HiveService.isLoggedIn();
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      context.go('/home');
    } else {
      // ignore: use_build_context_synchronously
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
