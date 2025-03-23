import 'package:event_prokit/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CongressPartnersScreen extends StatefulWidget {
  @override
  _CongressPartnersScreenState createState() => _CongressPartnersScreenState();
}

class _CongressPartnersScreenState extends State<CongressPartnersScreen> {
  late Future<List<dynamic>> _partnersData;

  @override
  void initState() {
    super.initState();
    _partnersData = fetchPartners();
  }

  // Function to fetch data from the API
  Future<List<dynamic>> fetchPartners() async {
    final String apiUrl = 'http://49.13.202.68:5001/api/partnersapp';

    // Retrieve the access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('No access token found in SharedPreferences');
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data'); // Debug: Log the response
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return data['data']; // Return the list inside 'data'
        } else if (data is List) {
          return data; // Return the list directly if no 'data' wrapper
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load partners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching partners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn
          ? Colors.grey[900] // Dark mode background
          : Colors.grey[100], // Light mode background
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Feed",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Partners List
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _partnersData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final partners = snapshot.data!
                        .where((partner) => partner['approve'] == true)
                        .toList(); // Filter for approved partners only
                    if (partners.isEmpty) {
                      return Center(child: Text('No approved partners available'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: partners.length,
                      itemBuilder: (context, index) {
                        final partner = partners[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          child: PartnerCard(
                            name: partner['name'] ?? 'Unknown',
                            logo: partner['image'] ?? 'https://via.placeholder.com/50',
                            description: partner['description'] ?? 'No description available',
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final String name;
  final String logo;
  final String description;

  const PartnerCard({
    required this.name,
    required this.logo,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartnerDetailScreen(
              name: name,
              logo: logo,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0), // Adds a 12.0 gap below each card
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                logo,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2A7C76),
                        Color(0xFF1A5C56),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0] : '?', // Check for empty string
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerDetailScreen extends StatelessWidget {
  final String name;
  final String logo;
  final String description;

  const PartnerDetailScreen({
    required this.name,
    required this.logo,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2A7C76),
                          Color(0xFF1A5C56),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            logo,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF2A7C76),
                                    Color(0xFF1A5C56),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty ? name[0] : '?', // Check for empty string
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      delay: Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About Partner",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}