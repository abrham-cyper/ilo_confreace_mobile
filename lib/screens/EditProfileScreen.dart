import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:event_prokit/main.dart'; // For appStore
import 'package:event_prokit/utils/EAColors.dart';
import 'package:nb_utils/nb_utils.dart'; // Your app colors

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController(text: "maysasha@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "••••••••");
  final TextEditingController phoneController = TextEditingController(text: "+1 415.111.0000");
  final TextEditingController cityStateController = TextEditingController(text: "San Francisco, CA");
  final TextEditingController countryController = TextEditingController(text: "USA");
  final TextEditingController bioController = TextEditingController(text: "Event enthusiast and tech lover.");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    cityStateController.dispose();
    countryController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.isDarkModeOn
            ? Colors.grey[900] // Dark mode background
            : Colors.grey[100], // Light mode background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel action
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: appStore.isDarkModeOn ? white : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: appStore.isDarkModeOn ? white : black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Save action (e.g., update profile data)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile saved!")),
                );
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: primaryColor1,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              // Profile Picture with Edit Icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appStore.isDarkModeOn ? cardDarkColor : Colors.grey[300]!,
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "https://example.com/profile.jpg", // Replace with actual image URL
                      ),
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor1,
                        border: Border.all(color: white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Email Field
              _buildTextField(
                label: "YOUR EMAIL",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Password Field
              _buildTextField(
                label: "YOUR PASSWORD",
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 16),
              // Phone Field
              _buildTextField(
                label: "YOUR PHONE",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              // Bio Field
              _buildTextField(
                label: "YOUR BIO",
                controller: bioController,
                maxLines: 3, // Allow multiple lines for bio
              ),
              SizedBox(height: 16),
              // City, State Field
              _buildTextField(
                label: "CITY, STATE",
                controller: cityStateController,
              ),
              SizedBox(height: 16),
              // Country Field
              _buildTextField(
                label: "COUNTRY",
                controller: countryController,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            // color: appStore.isDarkModeOn ? secondaryTextDark : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 16,
            color: appStore.isDarkModeOn ? white : black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: appStore.isDarkModeOn ? cardDarkColor : Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor1, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}