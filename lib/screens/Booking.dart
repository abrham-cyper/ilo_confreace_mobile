import 'dart:convert';
import 'package:event_prokit/screens/UserDetailsScreen.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// User Model
class User {
  final Name fullName;
  final String email;
  final String nationality;
  final String? jobTitle;
  final String? organizationName;
  final String subscription;
  final bool paymentStatus;
  final DateTime createdAt;
  final String? photo;
  final String? id;
  final String? roleInConference;
  final String? passportNumber;
  final String? mailingAddress;
  final String? alternativePhoneNumber;
  final String? phoneNumber;
  final String? gender;

  User({
    required this.fullName,
    required this.email,
    required this.nationality,
    this.jobTitle,
    this.organizationName,
    required this.subscription,
    required this.paymentStatus,
    required this.createdAt,
    this.photo,
    this.id,
    this.roleInConference,
    this.passportNumber,
    this.mailingAddress,
    this.alternativePhoneNumber,
    this.phoneNumber,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: Name.fromJson(json['fullName'] ?? {'first': '', 'middle': '', 'last': ''}),
      email: json['email'] ?? 'Unknown',
      nationality: json['nationality'] ?? 'Unknown',
      jobTitle: json['jobTitle'],
      organizationName: json['organizationName'],
      subscription: json['subscription'] ?? 'None',
      paymentStatus: json['paymentStatus'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      photo: json['photo'],
      id: json['_id'],
      roleInConference: json['roleInConference'],
      passportNumber: json['passportNumber'],
      mailingAddress: json['mailingAddress'],
      alternativePhoneNumber: json['alternativePhoneNumber'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
    );
  }
}

class Name {
  final String first;
  final String middle;
  final String last;

  Name({
    required this.first,
    required this.middle,
    required this.last,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      first: json['first'] ?? '',
      middle: json['middle'] ?? '',
      last: json['last'] ?? '',
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    const String apiUrl = 'http://49.13.202.68:5001/api/registerUser';

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        // Handle different possible JSON structures
        List<dynamic> userList;
        if (jsonData is List<dynamic>) {
          userList = jsonData; // Direct list: [...]
        } else if (jsonData is Map<String, dynamic>) {
          // Check common keys like "data", "users", or "result"
          if (jsonData.containsKey('data')) {
            userList = jsonData['data'] as List<dynamic>;
          } else if (jsonData.containsKey('users')) {
            userList = jsonData['users'] as List<dynamic>;
          } else if (jsonData.containsKey('result')) {
            userList = jsonData['result'] as List<dynamic>;
          } else {
            // If it's a single user object, wrap it in a list
            if (jsonData.containsKey('_id') || jsonData.containsKey('email')) {
              userList = [jsonData];
            } else {
              throw Exception('Unexpected JSON structure: no recognizable list key found');
            }
          }
        } else {
          throw Exception('Unexpected JSON format: not a list or map');
        }

        setState(() {
          users = userList.map((json) => User.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load data: ${response.statusCode}\n${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
      print('Error details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue.shade700,
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: fetchUsers,
                                child: Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: fetchUsers,
                          color: Colors.blue.shade700,
                          child: users.isEmpty
                              ? Center(
                                  child: Text(
                                    'No cards set yet',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    if (index >= 0 && index < users.length) {
                                      return UserTicketCard(user: users[index]);
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 8),
              Text(
                'My pass',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserTicketCard extends StatelessWidget {
  final User user;

  const UserTicketCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(user: user),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16), // Fixed to bottom: 16
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          user.createdAt.day.toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getMonth(user.createdAt.month),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          user.createdAt.year.toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${user.fullName.first} ${user.fullName.last}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                user.paymentStatus ? 'PAID' : 'PENDING',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: user.paymentStatus
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Email: ${user.email}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4),
                              Text(
                                user.nationality,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.subscriptions,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Subscription: ${user.subscription}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Joined: ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 70,
              top: -10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: -10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }
}

void main() {
  runApp(MaterialApp(
    home: UserListScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[100],
    ),
  ));
}