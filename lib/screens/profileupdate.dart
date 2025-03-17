import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/utils/EAColors.dart'; // Your app's color constants
import 'package:event_prokit/utils/EAapp_widgets.dart'; // Your app's widget utilities

class ProfileUpdateScreen extends StatefulWidget {
  final String email; // Email to identify the user

  const ProfileUpdateScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  String? _selectedGender;
  String? _selectedCountry;
  File? _profileImage;
  bool isLoading = false;
  String? errorMessage;

  // API URL for updating profile (adjust to your backend)
  final String updateProfileApiUrl = 'http://192.168.65.25:5000/api/user/update-profile';

  // Gender options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Country options (you can expand this list)
  final List<String> countryOptions = [
    'USA',
    'Canada',
    'UK',
    'Australia',
    'India',
    'Germany',
    'France',
    'Brazil',
    'Japan',
    'South Africa',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load existing user data if available
  }

  // Load existing user data (optional, if you want to prefill fields)
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final response = await http.get(
        Uri.parse('http://192.168.65.25:5000/api/user/profile?email=${widget.email}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _fullnameController.text = userData['fullname'] ?? '';
          _selectedGender = userData['gender'];
          _selectedCountry = userData['country'];
          // If profilePic is a URL, you can handle displaying it here
        });
      } else {
        toast('Failed to load user data');
      }
    } catch (e) {
      toast('Error loading user data');
    }
  }

  // Pick profile image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Update profile via API
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      // Prepare multipart request for image upload (if image is selected)
      var request = http.MultipartRequest('POST', Uri.parse(updateProfileApiUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['email'] = widget.email;
      request.fields['fullname'] = _fullnameController.text;
      if (_selectedGender != null) request.fields['gender'] = _selectedGender!;
      if (_selectedCountry != null) request.fields['country'] = _selectedCountry!;

      // Add profile image if selected
      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('profilePic', _profileImage!.path));
      }

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        toast('Profile updated successfully');
        // Navigate back or to another screen
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = responseData['error'] ?? 'Failed to update profile';
        });
        toast(errorMessage);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: Please check your connection';
      });
      toast(errorMessage);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor1,
          title: Text('Update Profile', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor1, width: 2),
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _profileImage == null
                                ? Icon(Icons.person, size: 60, color: primaryColor1)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: primaryColor1,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    30.height,

                    // Fullname Field
                    TextFormField(
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: primaryColor1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    20.height,

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: primaryColor1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor1),
                        ),
                      ),
                      items: genderOptions.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                    ),
                    20.height,

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(color: primaryColor1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor1),
                        ),
                      ),
                      items: countryOptions.map((country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a country';
                        }
                        return null;
                      },
                    ),
                    30.height,

                    // Error message display
                    if (errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (errorMessage != null) 15.height,

                    // Save Button
                    SizedBox(
                      width: context.width(),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                "Save Profile",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
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

  @override
  void dispose() {
    _fullnameController.dispose();
    super.dispose();
  }
}