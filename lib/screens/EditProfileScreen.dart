import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:event_prokit/main.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileService {
  static const String baseUrl = '${AppConstants.baseUrl}';

  Future<bool> updateProfile({
    required String fullName,
    String? country,
    String? bio,
    File? profilePic, // Note: For JSON, we'll need to handle file differently
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken == null) throw 'No authentication token found';

      print('Access Token: $accessToken');

      // Prepare JSON body
      Map<String, dynamic> body = {
        'fullname': fullName,
      };
      if (country != null) body['country'] = country;
      if (bio != null) body['bio'] = bio;
      // For profilePic with JSON, you'll need to send a URL or base64 string
      // For now, we'll skip profilePic since JSON typically doesn't handle raw files
      // If you need file upload, you'll need to use a separate endpoint or stick with multipart

      print('Request Body: ${jsonEncode(body)}');

      final response = await http.put(
        Uri.parse('$baseUrl/api/user/update-profile'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        return true;
      } else {
        final error = jsonResponse['error'] ?? jsonResponse['message'] ?? 'Failed to update profile';
        throw error;
      }
    } catch (e) {
      print('Update Profile Error: $e');
      throw e.toString();
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final ProfileService _profileService = ProfileService();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    countryController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      toast("Error picking image: $e");
    }
  }

  Future<void> _updateProfile() async {
    if (fullNameController.text.isEmpty) {
      toast("Full name cannot be empty");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _profileService.updateProfile(
        fullName: fullNameController.text,
        country: countryController.text.isNotEmpty ? countryController.text : null,
        bio: bioController.text.isNotEmpty ? bioController.text : null,
        profilePic: _profileImage, // Note: This won't be sent in JSON
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.isDarkModeOn ? Colors.grey[900] : Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: appStore.isDarkModeOn ? white : black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appStore.isDarkModeOn ? Colors.grey[700]! : Colors.grey[300]!,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person_outline,
                                size: 60,
                                color: appStore.isDarkModeOn ? Colors.grey[600] : Colors.grey[500],
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor1,
                            border: Border.all(color: white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              _buildSectionTitle("Personal Information"),
              SizedBox(height: 16),
              _buildTextField(
                label: "Full Name",
                controller: fullNameController,
                hintText: "Enter your full name",
              ),
              SizedBox(height: 32),
              _buildSectionTitle("Location"),
              SizedBox(height: 16),
              _buildTextField(
                label: "Country",
                controller: countryController,
                hintText: "Enter your country",
              ),
              SizedBox(height: 32),
              _buildSectionTitle("About You"),
              SizedBox(height: 16),
              _buildTextField(
                label: "Bio",
                controller: bioController,
                maxLines: 4,
                hintText: "Tell us about yourself",
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor1,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: white)
                      : Text(
                          "Save Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: appStore.isDarkModeOn ? white : black,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: appStore.isDarkModeOn ? Colors.grey[400] : Colors.grey[700],
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
            hintText: hintText,
            hintStyle: TextStyle(
              color: appStore.isDarkModeOn ? Colors.grey[600] : Colors.grey[400],
            ),
            filled: true,
            fillColor: appStore.isDarkModeOn ? Colors.grey[800] : Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: appStore.isDarkModeOn ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor1, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfileScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}