import 'package:event_prokit/screens/ListEvent.dart';
import 'package:event_prokit/screens/profileupdate.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/screens/EAForYouTabScreen.dart';
import 'package:event_prokit/screens/EATrendingTabScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // For SystemNavigator

import 'EAFilterScreen.dart';

class EAHomeScreen extends StatefulWidget {
  final String? name;

  EAHomeScreen({this.name});

  @override
  EAHomeScreenState createState() => EAHomeScreenState();
}

class EAHomeScreenState extends State<EAHomeScreen> {
  final _kTabs = <Tab>[
    Tab(text: 'FOR YOU'),
    Tab(text: 'Events feeds'),
    Tab(text: 'Events'),
  ];

  final _kTabPages = <Widget>[
    EAForYouTabScreen(),
    EATrendingTabScreen(),
    ListEvent()
  ];
  

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkUserEmailStatus();
    });
  }

  // Function to fetch email from SharedPreferences
  Future<String?> _getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Function to check if profile is already completed
  Future<bool> _isProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('profile_completed') ?? false;
  }

  // Function to check email status via POST API
  Future<bool> checkUserEmailStatus() async {
    if (await _isProfileCompleted()) {
      print("Profile already completed, skipping check");
      return false;
    }

    try {
      final email = await _getStoredEmail();
      if (email == null) {
        print("No email found in SharedPreferences");
        return false;
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/user/email-checker'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final exists = data['exists'] as bool?;
        final message = data['message'] as String?;

        print("Parsed 'exists': $exists");
        print("Parsed 'message': $message");

        if (exists == false && message == "Email is registered but fullname is missing") {
          print("Condition met, showing profile update popup");
          _showProfileUpdatePopup(email);
          return true;
        } else {
          print("Condition not met: exists=$exists, message=$message");
          return false;
        }
      } else {
        print("Failed to check email status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error checking email status: $e");
      return false;
    }
  }

  // Function to show Profile Update popup with back button handling
  void _showProfileUpdatePopup(String email) {
    if (!mounted) {
      print("Widget not mounted, cannot show popup");
      return;
    }
    print("Showing profile update popup for email: $email");
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Exit the app when back button is pressed
            SystemNavigator.pop();
            return false; // Prevent default back navigation
          },
          child: ProfileUpdateDialog(email: email),
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.name != null
          ? "Plan in ${widget.name}"
          : "20th ILO Regional Conference"),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          DefaultTabController(
            length: _kTabs.length,
            child: Column(
              children: <Widget>[
                Container(
                  width: context.width(),
                  child: Material(
                    color: context.cardColor,
                    child: TabBar(
                      tabs: _kTabs,
                      indicatorColor: primaryColor1,
                      labelColor: primaryColor1,
                      unselectedLabelColor: grey,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: _kTabPages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void launch(BuildContext context) {}
}

// Custom Animated Dialog Widget for Profile Update
class ProfileUpdateDialog extends StatefulWidget {
  final String email;

  const ProfileUpdateDialog({required this.email});

  @override
  _ProfileUpdateDialogState createState() => _ProfileUpdateDialogState();
}

class _ProfileUpdateDialogState extends State<ProfileUpdateDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_fullNameController.text.isEmpty) {
      toast("Full Name is required");
      return;
    }
    if (_countryController.text.isEmpty) {
      toast("Country is required");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profileData = {
        'email': widget.email,
        'fullname': _fullNameController.text,
        'country': _countryController.text,
        'bio': _bioController.text,
      };

      print("Sending profile data: $profileData");

      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}/api/user/update-profile'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profileData),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('profile_completed', true);
        Navigator.of(context).pop();
        toast("Profile updated successfully!", bgColor: Colors.green);
      } else {
        toast("Failed to update profile: ${response.body}", bgColor: Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error updating profile: $e");
      toast("Error updating profile: $e", bgColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                48,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor1, primaryColor2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: white,
                      child: Icon(Icons.person, size: 50, color: primaryColor1),
                    ),
                  ],
                ),
                16.height,
                Text(
                  "Let’s Get Started!",
                  style: boldTextStyle(size: 24, color: primaryColor1),
                ),
                8.height,
                Text(
                  "Complete your profile to unlock the full experience",
                  style: secondaryTextStyle(size: 14, color: grey),
                  textAlign: TextAlign.center,
                ),
                24.height,
                _buildTextField(_fullNameController, "Full Name", Icons.person),
                16.height,
                _buildTextField(_countryController, "Country", Icons.flag),
                16.height,
                _buildTextField(_bioController, "Bio (Optional)", Icons.edit, maxLines: 2),
                24.height,
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor1,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: white),
                            8.width,
                            Text("Save & Continue", style: boldTextStyle(color: white)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.done,
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: grey),
          prefixIcon: Icon(icon, color: primaryColor1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }
}