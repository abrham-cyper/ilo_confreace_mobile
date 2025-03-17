import 'package:event_prokit/utils/constants.dart'; // Added as requested
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Assuming EAPeopleScreen is defined elsewhere in your project
// import 'path_to_ea_people_screen.dart'; // Uncomment and adjust the path

class UserDetailScreen extends StatefulWidget {
  final String userId; // Receiver's userId
  const UserDetailScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = 'http://49.13.202.68:5001/api/user/userid/${widget.userId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['exists'] ? data['user'] : {};
          isLoading = false;
        });
      } else {
        _handleError(response.statusCode);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    setState(() {
      userData = {};
      isLoading = false;
    });
    log('Error: $error');
  }

  Future<void> _startConversation() async {
    final prefs = await SharedPreferences.getInstance();
    final senderUserId = prefs.getString('userid'); // Sender's userId from SharedPreferences
    final receiverUserId = widget.userId; // Receiver's userId from parameter

    if (senderUserId == null || receiverUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User IDs are missing")),
      );
      return;
    }

    final url = 'http://49.13.202.68:4000/api/conversations';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderUsername': senderUserId,
          'receiverUsername': receiverUserId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final conversationId = data['conversationId'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Conversation started: $conversationId")),
        );
        // Navigate to EAPeopleScreen after successful conversation start
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EAPeopleScreen(), // Replace with your EAPeopleScreen widget
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to start conversation: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: boldTextStyle(size: 22, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          if (!isLoading && userData != null && userData!.isNotEmpty)
            IconButton(
              icon: Icon(Icons.message, color: Colors.white),
              onPressed: _startConversation,
              tooltip: 'Send Message',
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : userData!.isEmpty
              ? Center(child: Text("No user data", style: secondaryTextStyle(size: 18)))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildDetailsCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue])),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: userData!['profilePic'] != null
                ? NetworkImage(userData!['profilePic'])
                : AssetImage('assets/default_profile.png') as ImageProvider,
            child: userData!['profilePic'] == null ? Icon(Icons.person, size: 50) : null,
          ),
          SizedBox(height: 16),
          Text(userData!['fullname'] ?? 'N/A', style: boldTextStyle(size: 24, color: Colors.white)),
          SizedBox(height: 8),
          Text(userData!['email'] ?? 'N/A', style: secondaryTextStyle(size: 16, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItem(Icons.location_on, "Country", userData!['country'] ?? 'N/A'),
              Divider(),
              _buildItem(Icons.description, "Bio", userData!['bio'] ?? 'N/A', isBio: true),
              if (userData!['gender'] != null) ...[
                Divider(),
                _buildItem(Icons.person_outline, "Gender", userData!['gender']),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value, {bool isBio = false}) {
    return Row(
      crossAxisAlignment: isBio ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle(size: 16, color: Colors.grey.shade700)),
              SizedBox(height: 4),
              Text(value, style: primaryTextStyle(size: 16), maxLines: isBio ? null : 1),
            ],
          ),
        ),
      ],
    );
  }
}

// Placeholder for EAPeopleScreen (replace with your actual implementation)
class EAPeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EA People Screen")),
      body: Center(child: Text("Welcome to EA People Screen!")),
    );
  }
}