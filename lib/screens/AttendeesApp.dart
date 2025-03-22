import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const AttendeesApp());
}

class AttendeesApp extends StatelessWidget {
  const AttendeesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendees Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE6F0FA), // Light blue background
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const AttendeesScreen(),
    );
  }
}

class Attendee {
  final String name;
  final String title;
  final String company;
  final String email;
  final String bio;
  bool isFriendRequestSent;

  Attendee({
    required this.name,
    required this.title,
    required this.company,
    required this.email,
    required this.bio,
    this.isFriendRequestSent = false,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      name: json['name'],
      title: json['title'],
      company: json['company'],
      email: json['email'],
      bio: json['bio'],
    );
  }
}

class AttendeesScreen extends StatefulWidget {
  const AttendeesScreen({super.key});

  @override
  State<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  List<Attendee> attendees = [];

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  void _loadAttendees() {
    // Sample JSON data (in a real app, this would come from an API)
    const String jsonString = '''
    [
      {
        "name": "Will Marvin",
        "title": "Musician",
        "company": "N/A",
        "email": "will.marvin@example.com",
        "bio": "Passionate musician with a love for live performances"
      },
      {
        "name": "Holden Kuphal",
        "title": "Educator",
        "company": "N/A",
        "email": "holden.k@example.com",
        "bio": "Dedicated educator focused on innovative teaching methods"
      },
      {
        "name": "Newton Littel",
        "title": "HR Specialist",
        "company": "N/A",
        "email": "newton.l@example.com",
        "bio": "Experienced HR specialist with a focus on employee engagement"
      },
      {
        "name": "Candice Padberg",
        "title": "Patrol Officer",
        "company": "N/A",
        "email": "candice.p@example.com",
        "bio": "Committed patrol officer ensuring community safety"
      },
      {
        "name": "Justice Fisher",
        "title": "Zoologist",
        "company": "N/A",
        "email": "justice.f@example.com",
        "bio": "Zoologist passionate about wildlife conservation"
      }
    ]
    ''';

    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      attendees = jsonData.map((json) => Attendee.fromJson(json)).toList();
      // Set the first attendee as having a friend request sent (to match the UI)
      if (attendees.isNotEmpty) {
        attendees[0].isFriendRequestSent = true;
      }
    });
  }

  void _toggleFriendRequest(Attendee attendee) {
    setState(() {
      attendee.isFriendRequestSent = !attendee.isFriendRequestSent;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(attendee.isFriendRequestSent
            ? 'Friend request sent to ${attendee.name}'
            : 'Friend request cancelled for ${attendee.name}'),
      ),
    );
  }

  void _showAttendeeDetails(BuildContext context, Attendee attendee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(attendee.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${attendee.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${attendee.email}'),
              const SizedBox(height: 8),
              Text('Bio: ${attendee.bio}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent to ${attendee.name}')),
              );
              Navigator.pop(context);
            },
            child: const Text('Message'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for New Friends',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Main Content (Right-side UI)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Import Your Friends',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Taming Advanced Color Palettes in Photoshop, Sketch And Affinity Designer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      // Social Media Buttons
                    
                  
                      const SizedBox(height: 10),
                      // Recommended Friends List
                      attendees.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2, // Only show 2 attendees as in the UI
                              itemBuilder: (context, index) {
                                final attendee = attendees[index];
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150?text=${attendee.name[0]}',
                                        ),
                                      ),
                                      title: Text(
                                        attendee.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        attendee.title,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () => _toggleFriendRequest(attendee),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: attendee.isFriendRequestSent
                                                ? Colors.red
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Icon(
                                            attendee.isFriendRequestSent
                                                ? Icons.check
                                                : Icons.add,
                                            color: attendee.isFriendRequestSent
                                                ? Colors.white
                                                : Colors.black54,
                                          ),
                                        ),
                                      ),
                                      onTap: () => _showAttendeeDetails(context, attendee),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
 
    );
  }

  // Helper method to build social media buttons
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: 30,
        ),
      ),
    );
  }
}