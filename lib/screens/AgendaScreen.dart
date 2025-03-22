import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: AgendaScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<Map<String, dynamic>> _cardData;

  @override
  void initState() {
    super.initState();
    _cardData = fetchCardData();
  }

  Future<Map<String, dynamic>> fetchCardData() async {
  final prefs = await SharedPreferences.getInstance();
  String? eventId = prefs.getString('event_id');
  String? accessToken = prefs.getString('accessToken');

  if (eventId == null) {
    eventId = '67dbf1d743c7b67904dc6eb7';
    await prefs.setString('event_id', eventId);
  }

  if (accessToken == null) {
    print('No access token found. User may not be logged in.');
    throw Exception('Please log in to access card data');
  }

  try {
    final response = await http.get(
      Uri.parse('http://49.13.202.68:5001/api/cards/$eventId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as Map<String, dynamic>? ?? {};
    } else {
      throw Exception('Failed to load card data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6F0FA),
              Color(0xFFD0E8E4),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _cardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final cardData = snapshot.data!;
            final List<dynamic> agendaDays = cardData['agenda'] as List<dynamic>? ?? [];

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2A7C76)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    pinned: true,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        FadeInLeft(
                          child: const Text(
                            "Agenda",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (agendaDays.isEmpty)
                          const Center(child: Text('No agenda items available'))
                        else
                          ...agendaDays.asMap().entries.map((entry) {
                            int index = entry.key;
                            final day = entry.value as Map<String, dynamic>;

                            return FadeInUp(
                              delay: Duration(milliseconds: 100 * index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF2A7C76),
                                            Color(0xFF1A5C56),
                                          ],
                                        ),
                                        // borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        day['day']?.toString() ?? 'Day Not Specified',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...(day['events'] as List<dynamic>? ?? []).asMap().entries.map((eventEntry) {
                                      int eventIndex = eventEntry.key;
                                      final event = eventEntry.value as Map<String, dynamic>;
                                      final List<String> speakers = (event['speakers'] as List<dynamic>? ?? [])
                                          .map((speaker) {
                                            final speakerData = speaker as Map<String, dynamic>;
                                            return '${speakerData['name'] ?? 'Unknown'}, ${speakerData['role'] ?? 'No role'}';
                                          }).toList();

                                      return FadeInRight(
                                        delay: Duration(milliseconds: 100 * eventIndex),
                                        child: EventCard(
                                          time: event['time']?.toString() ?? 'N/A',
                                          title: event['title']?.toString() ?? 'Untitled Event',
                                          description: event['description']?.toString() ?? 'No description',
                                          location: event['location']?.toString() ?? 'N/A',
                                          type: event['type']?.toString() ?? 'N/A',
                                          speakers: speakers,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final String location;
  final String type;
  final List<String> speakers;

  const EventCard({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.speakers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2A7C76),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A7C76).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2A7C76),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Color(0xFF2A7C76),
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (speakers.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Speakers:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            ...speakers.map((speaker) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    speaker,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}