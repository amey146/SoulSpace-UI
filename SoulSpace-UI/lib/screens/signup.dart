import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soul/services/hive_service.dart';
import 'package:soul/models/user_profile.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),

          // Sign-up Form UI
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon or Avatar at the top
                      const CircleAvatar(
                        radius: 37.0,
                        backgroundColor: Color.fromARGB(195, 155, 148, 148),
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 34.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Title
                      const Text(
                        'Sign-Up',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 22.0),

                      // Full Name TextField
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.white),
                          hintText: 'Enter your Full Name',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color.fromARGB(169, 26, 14, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16.0),

                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          hintText: 'Enter your E-mail Id',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color.fromARGB(169, 26, 14, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16.0),

                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          hintText: 'Create a strong password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color.fromARGB(169, 26, 14, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16.0),

                      // Confirm Password TextField
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          hintText: 'Confirm your password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color.fromARGB(169, 26, 14, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 16.0),

                      // Terms and Conditions Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey.withOpacity(.32);
                              }
                              return const Color(0xFF5C166E);
                            }),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _acceptedTerms = !_acceptedTerms;
                                });
                              },
                              child: const Text(
                                'I accept the Terms and Conditions',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),

                      // Register Button
                      ElevatedButton(
                        onPressed: _isLoading || !_acceptedTerms
                            ? null
                            : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 95.0),
                          backgroundColor: const Color(0xFF5C166E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Register',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white70)),
                      ),

                      const SizedBox(height: 20.0),

                      // Continue with Google
                      const Text('Or', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 12.0),

                      ElevatedButton.icon(
                        onPressed: _handleGoogleSignUp,
                        icon: Image.asset(
                          'assets/google.png',
                          height: 28.0,
                          width: 30.0,
                        ),
                        label: const Text('Continue with Google'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),

                      // Login Text
                      const SizedBox(height: 24.0),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Already have account? LOGIN',
                          style: TextStyle(color: Colors.white70),
                        ),
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please accept the Terms and Conditions')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final bool success = await HiveService.signUp(
            _emailController.text, _passwordController.text);

        if (success) {
          await HiveService.setCurrentUser(_emailController.text);
          await HiveService.saveUserProfile(UserProfile(
            name: _nameController.text,
            email: _emailController.text,
            phoneNumber: '',
            dateOfBirth: DateTime.now(),
            city: '',
          ));

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Sign up successful! Proceeding to questionnaire...'),
              duration: Duration(seconds: 2),
            ),
          );

          // Delay navigation to allow the user to see the success message
          await Future.delayed(const Duration(seconds: 2));
          context.push('/questionnaire');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('An account with this email already exists')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _handleGoogleSignUp() {
    // For now, just show a message that this feature is not available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Google Sign Up is not available in this version.')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
