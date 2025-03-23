import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      debugShowCheckedModeBanner: false,
      home: const AttendeesScreen(),
    );
  }
}

class Attendee {
  final String? name;
  final String? title;
  final String? company;
  final String? email;
  final String? bio;
  final bool paymentStatus;

  Attendee({
    this.name,
    this.title,
    this.company,
    this.email,
    this.bio,
    required this.paymentStatus,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    final fullName = json['fullName'] as Map<String, dynamic>?;
    String? name;
    if (fullName != null) {
      final first = fullName['first'] as String?;
      final last = fullName['last'] as String?;
      if (first != null && last != null) {
        name = "$first $last";
      } else if (first != null) {
        name = first;
      } else if (last != null) {
        name = last;
      }
    }

    return Attendee(
      name: name,
      title: json['jobTitle'] as String?,
      company: json['organizationName'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?, // Bio not provided in API, but included for future use
      paymentStatus: json['paymentStatus'] ?? false,
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
  List<Attendee> filteredAttendees = [];
  bool sortAscending = true;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAttendees();
    searchController.addListener(_filterAttendees);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttendees() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        setState(() {
          errorMessage = 'Access token not found. Please log in.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://49.13.202.68:5001/api/registerUser'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');

        if (response.body.isEmpty) {
          throw Exception('Empty response from server');
        }

        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData == null) {
          throw Exception('Invalid JSON response: null data');
        }

        List<dynamic> userList;
        if (jsonData is Map<String, dynamic>) {
          userList = [jsonData];
        } else if (jsonData is List<dynamic>) {
          userList = jsonData;
        } else {
          throw Exception('Unexpected response format: ${jsonData.runtimeType}');
        }

        setState(() {
          attendees = userList
              .map((json) => Attendee.fromJson(json as Map<String, dynamic>))
              .where((attendee) => attendee.paymentStatus)
              .toList();
          filteredAttendees = attendees;
          isLoading = false;

          if (attendees.isEmpty) {
            errorMessage = 'No contacts exist with payment status true';
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode} - ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  void _filterAttendees() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredAttendees = attendees.where((attendee) {
        return attendee.name?.toLowerCase().contains(query) ?? false;
      }).toList();
      filteredAttendees.sort((a, b) => sortAscending
          ? (a.name ?? '').compareTo(b.name ?? '')
          : (b.name ?? '').compareTo(a.name ?? ''));
    });
  }

  void _sortAttendees() {
    setState(() {
      sortAscending = !sortAscending;
      filteredAttendees.sort((a, b) => sortAscending
          ? (a.name ?? '').compareTo(b.name ?? '')
          : (b.name ?? '').compareTo(a.name ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _sortAttendees,
            child: Text(
              sortAscending ? 'Sort A-Z' : 'Sort Z-A',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                controller: searchController,
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
            // Contacts List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : filteredAttendees.isEmpty
                          ? const Center(child: Text('No contacts exist with payment status true'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: filteredAttendees.length,
                              itemBuilder: (context, index) {
                                final attendee = filteredAttendees[index];
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: ListTile(
                                    leading: Hero(
                                      tag: 'avatar-${attendee.name ?? 'unknown'}',
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150?text=${attendee.name?[0] ?? 'U'}',
                                        ),
                                      ),
                                    ),
                                    title: attendee.name != null
                                        ? Text(
                                            attendee.name!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    subtitle: attendee.email != null
                                        ? Text(
                                            attendee.email!,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              AttendeeDetailsScreen(attendee: attendee),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOut;
                                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                            var offsetAnimation = animation.drive(tween);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
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

class AttendeeDetailsScreen extends StatefulWidget {
  final Attendee attendee;

  const AttendeeDetailsScreen({super.key, required this.attendee});

  @override
  _AttendeeDetailsScreenState createState() => _AttendeeDetailsScreenState();
}

class _AttendeeDetailsScreenState extends State<AttendeeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with Back Button and Profile Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Hero(
                        tag: 'avatar-${widget.attendee.name ?? 'unknown'}',
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150?text=${widget.attendee.name?[0] ?? 'U'}',
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // To balance the layout
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              if (widget.attendee.name != null) ...[
                                Text(
                                  widget.attendee.name!,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (widget.attendee.title != null) ...[
                                Text(
                                  widget.attendee.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (widget.attendee.company != null) ...[
                                Text(
                                  widget.attendee.company!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (widget.attendee.email != null || widget.attendee.bio != null) ...[
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                              if (widget.attendee.email != null) ...[
                                const Text(
                                  'Contact Info',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.email, color: Colors.blue),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.attendee.email!,
                                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (widget.attendee.bio != null) ...[
                                const Text(
                                  'Bio',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.attendee.bio!,
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                                const SizedBox(height: 20),
                              ],
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Message sent to ${widget.attendee.name ?? 'this user'}')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Message',
                                    style: TextStyle(fontSize: 18),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Bounce Animation Widget
class BounceAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const BounceAnimation({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}