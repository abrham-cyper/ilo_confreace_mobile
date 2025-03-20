import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

class SpeakersScreen extends StatelessWidget {
  // JSON data for speakers with more detailed information
  final String speakersJson = '''
  {
    "title": "Key Participants of 2025 ILO Regional Conference",
    "speakers": [
      {
        "name": "Gilbert F. Houngbo",
        "role": "ILO Director-General",
        "image": "https://example.com/gilbert.jpg",
        "isOnline": true,
        "bio": "Gilbert F. Houngbo is the Director-General of the International Labour Organization, leading global efforts to promote social justice and decent work. With a background in international development, he has been instrumental in shaping labor policies worldwide.",
        "achievements": [
          "Led the adoption of the Global Coalition for Social Justice in 2023",
          "Advocated for decent work in the digital economy",
          "Expanded ILO programs in over 100 countries"
        ],
        "contact": {
          "email": "gilbert.houngbo@ilo.org",
          "linkedin": "linkedin.com/in/gilberthoungbo"
        }
      },
      {
        "name": "H.E. Luis Abinader",
        "role": "President of the Dominican Republic",
        "image": "https://example.com/luis.jpg",
        "isOnline": false,
        "bio": "Luis Abinader is the President of the Dominican Republic, known for his focus on economic reform and social development. He has hosted several international summits to promote sustainable growth in the region.",
        "achievements": [
          "Hosted the 20th American Regional Meeting of the ILO in 2025",
          "Implemented policies to boost tourism and employment",
          "Promoted renewable energy initiatives"
        ],
        "contact": {
          "email": "president@dominican.gov",
          "linkedin": "linkedin.com/in/luisabinader"
        }
      },
      {
        "name": "Dr. Maria Lopez",
        "role": "Digital Economy Expert",
        "image": "https://example.com/maria.jpg",
        "isOnline": true,
        "bio": "Dr. Maria Lopez is a renowned expert in the digital economy, specializing in the impact of technology on labor markets. She has advised multiple governments on digital transformation strategies.",
        "achievements": [
          "Published a bestselling book on digital labor trends",
          "Consulted for the UN on AI and employment",
          "Received the 2024 Tech Innovator Award"
        ],
        "contact": {
          "email": "maria.lopez@techconsult.org",
          "linkedin": "linkedin.com/in/marialopez"
        }
      },
      {
        "name": "Mr. John Kimani",
        "role": "Tech Industry Leader",
        "image": "https://example.com/john.jpg",
        "isOnline": false,
        "bio": "John Kimani is a tech industry leader with over 20 years of experience in software development and innovation. He is the CEO of a leading tech firm focused on sustainable solutions.",
        "achievements": [
          "Founded a tech company employing over 5,000 people",
          "Developed an award-winning app for remote work",
          "Spoke at the 2024 World Economic Forum"
        ],
        "contact": {
          "email": "john.kimani@techfirm.com",
          "linkedin": "linkedin.com/in/johnkimani"
        }
      },
      {
        "name": "Ms. Amina Hassan",
        "role": "Labor Policy Specialist",
        "image": "https://example.com/amina.jpg",
        "isOnline": true,
        "bio": "Amina Hassan is a labor policy specialist with a focus on social protection and inclusive labor markets. She has worked with the ILO on several initiatives to support marginalized workers.",
        "achievements": [
          "Designed a social protection framework for informal workers",
          "Led a global campaign for fair wages",
          "Published 10+ research papers on labor economics"
        ],
        "contact": {
          "email": "amina.hassan@ilo.org",
          "linkedin": "linkedin.com/in/aminahassan"
        }
      },
      {
        "name": "Mr. Carlos Rivera",
        "role": "Union Representative",
        "image": "https://example.com/carlos.jpg",
        "isOnline": false,
        "bio": "Carlos Rivera is a union representative advocating for workers' rights in the Dominican Republic. He has been a key figure in negotiating better working conditions for factory workers.",
        "achievements": [
          "Negotiated a 20% wage increase for factory workers",
          "Organized a national strike for labor rights",
          "Received the 2023 Worker Advocate Award"
        ],
        "contact": {
          "email": "carlos.rivera@union.org",
          "linkedin": "linkedin.com/in/carlosrivera"
        }
      },
      {
        "name": "Dr. Elena Martinez",
        "role": "Gender Equality Advocate",
        "image": "https://example.com/elena.jpg",
        "isOnline": true,
        "bio": "Dr. Elena Martinez is a passionate advocate for gender equality in the workplace. She has worked with international organizations to promote equal opportunities for women.",
        "achievements": [
          "Launched a global initiative for women in leadership",
          "Advised the UN on gender equality policies",
          "Authored a book on workplace diversity"
        ],
        "contact": {
          "email": "elena.martinez@genderequality.org",
          "linkedin": "linkedin.com/in/elenamartinez"
        }
      },
      {
        "name": "Mr. Rajesh Gupta",
        "role": "Environmental Economist",
        "image": "https://example.com/rajesh.jpg",
        "isOnline": false,
        "bio": "Rajesh Gupta is an environmental economist specializing in green jobs and sustainable economic transitions. He has advised governments on climate-friendly labor policies.",
        "achievements": [
          "Developed a framework for green job creation",
          "Consulted for the 2025 COP Climate Summit",
          "Published research on sustainable economics"
        ],
        "contact": {
          "email": "rajesh.gupta@enviroconsult.org",
          "linkedin": "linkedin.com/in/rajeshgupta"
        }
      },
      {
        "name": "Ms. Sofia Mendes",
        "role": "Climate Policy Advisor",
        "image": "https://example.com/sofia.jpg",
        "isOnline": true,
        "bio": "Sofia Mendes is a climate policy advisor working on the intersection of climate change and labor markets. She has been a key figure in promoting green jobs in the region.",
        "achievements": [
          "Advised on the ILO’s climate resilience strategy",
          "Led a campaign for renewable energy jobs",
          "Spoke at the 2024 UN Climate Conference"
        ],
        "contact": {
          "email": "sofia.mendes@climatepolicy.org",
          "linkedin": "linkedin.com/in/sofiamendes"
        }
      },
      {
        "name": "Ms. Clara Nguyen",
        "role": "Youth Employment Expert",
        "image": "https://example.com/clara.jpg",
        "isOnline": false,
        "bio": "Clara Nguyen is a youth employment expert focused on education and training programs. She has worked with the ILO to address youth unemployment in developing countries.",
        "achievements": [
          "Developed a training program for 10,000 youths",
          "Partnered with UNESCO on education initiatives",
          "Received the 2023 Youth Empowerment Award"
        ],
        "contact": {
          "email": "clara.nguyen@youthemployment.org",
          "linkedin": "linkedin.com/in/claranguyen"
        }
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    // Parse JSON data
    final Map<String, dynamic> speakersData = jsonDecode(speakersJson);
    final String title = speakersData['title'];
    final List<dynamic> speakers = speakersData['speakers'];

    return Scaffold(
      backgroundColor: Color(0xFFF5E9E2), // Light peach background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Back Button and Title
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              pinned: true,
            ),
            // Speakers Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final speaker = speakers[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: SpeakerCard(
                        name: speaker['name'],
                        role: speaker['role'],
                        image: speaker['image'],
                        isOnline: speaker['isOnline'],
                        bio: speaker['bio'],
                        achievements: List<String>.from(speaker['achievements']),
                        contact: speaker['contact'],
                      ),
                    );
                  },
                  childCount: speakers.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ],
        ),
      ),
   
    );
  }
}

class SpeakerCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;
  final bool isOnline;
  final String bio;
  final List<String> achievements;
  final Map<String, dynamic> contact;

  const SpeakerCard({
    required this.name,
    required this.role,
    required this.image,
    required this.isOnline,
    required this.bio,
    required this.achievements,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakerDetailScreen(
              name: name,
              role: role,
              image: image,
              isOnline: isOnline,
              bio: bio,
              achievements: achievements,
              contact: contact,
            ),
          ),
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
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
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOnline ? Colors.green : Colors.grey,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class SpeakerDetailScreen extends StatelessWidget {
  final String name;
  final String role;
  final String image;
  final bool isOnline;
  final String bio;
  final List<String> achievements;
  final Map<String, dynamic> contact;

  const SpeakerDetailScreen({
    required this.name,
    required this.role,
    required this.image,
    required this.isOnline,
    required this.bio,
    required this.achievements,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9E2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button and Speaker Image
              Stack(
                children: [
                  Container(
                    height: 300,
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
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 120,
                                  height: 120,
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
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isOnline ? Colors.green : Colors.grey,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
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
                        SizedBox(height: 4),
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Detailed Information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Biography
                    FadeInUp(
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
                              "Biography",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              bio,
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
                    // Achievements
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
                              "Achievements",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            ...achievements.map((achievement) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFA5A5),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        achievement,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Contact Information
                    FadeInUp(
                      delay: Duration(milliseconds: 400),
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
                              "Contact Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                  color: Color(0xFFFFA5A5),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Email: ${contact['email']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  size: 16,
                                  color: Color(0xFFFFA5A5),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "LinkedIn: ${contact['linkedin']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
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