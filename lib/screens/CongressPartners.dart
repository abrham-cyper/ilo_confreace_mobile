import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

class CongressPartnersScreen extends StatelessWidget {
  // JSON data for the congress partners
  final String partnersJson = '''
  {
    "title": "Congress Partners - 2025 ILO Regional Conference",
    "partners": [
      {
        "name": "World Economic Forum",
        "logo": "https://example.com/wef_logo.jpg",
        "description": "The World Economic Forum engages the foremost political, business, and cultural leaders to shape global, regional, and industry agendas. #ILORegional2025"
      },
      {
        "name": "United Nations",
        "logo": "https://example.com/un_logo.jpg",
        "description": "The United Nations promotes international cooperation and maintains international order. Partnering for sustainable development. #ILORegional2025"
      },
      {
        "name": "Green Jobs Initiative",
        "logo": "https://example.com/green_jobs_logo.jpg",
        "description": "The Green Jobs Initiative focuses on creating sustainable employment opportunities in the green economy. 🌱 #ILORegional2025"
      },
      {
        "name": "Global Labor Organization",
        "logo": "https://example.com/glo_logo.jpg",
        "description": "The Global Labor Organization supports research and policy development for fair labor practices worldwide. #ILORegional2025"
      },
      {
        "name": "Youth Employment Network",
        "logo": "https://example.com/yen_logo.jpg",
        "description": "The Youth Employment Network empowers young people with skills and opportunities for meaningful employment. #ILORegional2025"
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    // Parse JSON data
    final Map<String, dynamic> partnersData = jsonDecode(partnersJson);
    final String title = partnersData['title'];
    final List<dynamic> partners = partnersData['partners'];

    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // Light background like the design
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
                  // Removed the 3-dot icon (Icons.more_vert)
                ],
              ),
            ),
            // Partners List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: PartnerCard(
                      name: partner['name'],
                      logo: partner['logo'],
                      description: partner['description'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Removed the BottomNavigationBar
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
        margin: EdgeInsets.only(bottom: 12),
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
            // Partner Logo
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
                      name[0],
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
            // Partner Info
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
            // Removed the 3-dot icon (Icons.more_horiz)
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
              // Header with Back Button and Partner Logo
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
                                  name[0],
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
              // Description
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