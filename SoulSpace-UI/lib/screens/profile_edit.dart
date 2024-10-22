import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:soul/models/user_profile.dart';
import 'package:soul/services/hive_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await HiveService.getUserProfile();
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile.name;
        _emailController.text = userProfile.email;
        _phoneController.text = userProfile.phoneNumber;
        _cityController.text = userProfile.city;
        _selectedDate = userProfile.dateOfBirth;
        _dobController.text =
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final userProfile = UserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      dateOfBirth: _selectedDate,
      city: _cityController.text,
    );
    await HiveService.saveUserProfile(userProfile);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (val) {
                  setState(() {
                    _selectedDate = val;
                    _dobController.text = "${val.day}/${val.month}/${val.year}";
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff661080), Color(0xff2B0437)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          // Implement change picture functionality
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Change Picture',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _emailController,
                  labelText: 'Email id',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _dobController,
                  labelText: 'Date of birth',
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.white),
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: _cityController,
                  labelText: 'City',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveUserProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 80),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Color(0xff030103)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement change password functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 80),
                  ),
                  child: const Text(
                    'Change Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
