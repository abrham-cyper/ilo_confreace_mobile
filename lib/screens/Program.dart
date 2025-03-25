import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProgramApp());
}

class ProgramApp extends StatelessWidget {
  const ProgramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Program Directory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light gray background
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const Program(),
    );
  }
}

class Meeting {
  final String title;
  final String time;
  final String date; // Add date field
  final int participants;
  final String platform;
  final String category;

  Meeting({
    required this.title,
    required this.time,
    required this.date,
    required this.participants,
    required this.platform,
    required this.category,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      title: json['title'],
      time: json['time'],
      date: json['date'], // Parse date from JSON
      participants: json['participants'],
      platform: json['platform'],
      category: json['category'],
    );
  }
}

class Program extends StatefulWidget {
  const Program({super.key});

  @override
  State<Program> createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  List<Meeting> meetings = [];
  List<Meeting> filteredMeetings = []; // List to store filtered meetings
  int _selectedDateIndex = 2; // May 21 is selected by default
  final List<Map<String, dynamic>> _dates = [
    {'day': 'Fri', 'date': '19', 'fullDate': 'May 19, 2023'},
    {'day': 'Sat', 'date': '20', 'fullDate': 'May 20, 2023'},
    {'day': 'Sun', 'date': '21', 'fullDate': 'May 21, 2023'},
    {'day': 'Mon', 'date': '22', 'fullDate': 'May 22, 2023'},
    {'day': 'Tue', 'date': '23', 'fullDate': 'May 23, 2023'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }Future<void> _loadMeetings() async {
  try {
    // Retrieve the event_id and access token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventId = prefs.getString('event_id');
    String? accessToken = prefs.getString('accessToken');

    if (eventId == null) {
      print('No event_id found in SharedPreferences');
      setState(() {
        meetings = [];
        filteredMeetings = [];
      });
      return;
    }

    if (accessToken == null) {
      print('No access token found. User may not be logged in.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view meetings')),
      );
      setState(() {
        meetings = [];
        filteredMeetings = [];
      });
      return;
    }

    // Make the authenticated API call to fetch the card data
    final url = '${AppConstants.baseUrl}/api/cards/$eventId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> meetingData = jsonData['data']['meetings'] ?? [];

      setState(() {
        meetings = meetingData.map((json) => Meeting.fromJson(json)).toList();
        // Filter meetings based on the selected date
        _filterMeetings();
      });
    } else {
      print('Failed to load meetings: ${response.statusCode}');
      setState(() {
        meetings = [];
        filteredMeetings = [];
      });
    }
  } catch (error) {
    print('Error fetching meetings: $error');
    setState(() {
      meetings = [];
      filteredMeetings = [];
    });
  }
}

  void _filterMeetings() {
    final selectedDate = _dates[_selectedDateIndex]['fullDate'];
    filteredMeetings = meetings.where((meeting) => meeting.date == selectedDate).toList();
  }

  void _showMeetingDetails(BuildContext context, Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meeting.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Time: ${meeting.time}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Date: ${meeting.date}'),
              const SizedBox(height: 8),
              Text('Participants: ${meeting.participants}'),
              const SizedBox(height: 8),
              Text('Platform: ${meeting.platform}'),
              const SizedBox(height: 8),
              Text('Category: ${meeting.category}'),
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
                SnackBar(content: Text('Joined ${meeting.title}')),
              );
              Navigator.pop(context);
            },
            child: const Text('Join Meeting'),
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "See All" button press
                    },
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
                    onPressed: () {
                      // Handle previous month
                    },
                  ),
                  const Text(
                    'May, 2023',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                    onPressed: () {
                      // Handle next month
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final isSelected = index == _selectedDateIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                        _filterMeetings(); // Filter meetings when date changes
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            date['day'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date['date'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Meetings List
            Expanded(
              child: filteredMeetings.isEmpty
                  ? const Center(child: Text('No meetings for this date'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: filteredMeetings.length,
                      itemBuilder: (context, index) {
                        final meeting = filteredMeetings[index];
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.blue[50]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  meeting.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      meeting.time,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        // Participant avatars
                                        Stack(
                                          children: [
                                            const CircleAvatar(
                                              radius: 12,
                                              backgroundImage: NetworkImage(
                                                'https://via.placeholder.com/150',
                                              ),
                                            ),
                                            if (meeting.participants > 1)
                                              Positioned(
                                                left: 16,
                                                child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.grey[300],
                                                  child: Text(
                                                    '+${meeting.participants}',
                                                    style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          meeting.platform,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Chip(
                                  label: Text(
                                    meeting.category,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: Colors.orange[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onTap: () => _showMeetingDetails(context, meeting),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}