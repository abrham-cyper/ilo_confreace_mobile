import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

class AgendaScreen extends StatelessWidget {
  // Expanded JSON data for the agenda
  final String agendaJson = '''
  {
    "conference": "2025 ILO Regional Conference",
    "location": "Santo Domingo, Dominican Republic",
    "theme": "Shaping the Future of Work: Towards a Sustainable and Inclusive Region",
    "agenda": [
      {
        "day": "Day 1 - October 7, 2025",
        "events": [
          {
            "time": "08:00 AM - 09:00 AM",
            "title": "Registration and Welcome Coffee",
            "description": "Check-in for delegates and networking over coffee.",
            "location": "Main Lobby, Convention Center",
            "type": "Networking",
            "speakers": []
          },
          {
            "time": "09:00 AM - 10:00 AM",
            "title": "Opening Ceremony",
            "description": "Official welcome address and introduction to the conference theme.",
            "location": "Grand Ballroom",
            "type": "Plenary",
            "speakers": [
              "Gilbert F. Houngbo, ILO Director-General",
              "H.E. Luis Abinader, President of the Dominican Republic"
            ]
          },
          {
            "time": "10:30 AM - 12:00 PM",
            "title": "Keynote: The Future of Work in a Digital Age",
            "description": "Panel discussion on how digital transformation is reshaping labor markets.",
            "location": "Grand Ballroom",
            "type": "Panel",
            "speakers": [
              "Dr. Maria Lopez, Digital Economy Expert",
              "Mr. John Kimani, Tech Industry Leader"
            ]
          },
          {
            "time": "01:00 PM - 02:30 PM",
            "title": "Lunch Break and Networking",
            "description": "Buffet lunch with opportunities for informal discussions.",
            "location": "Terrace Hall",
            "type": "Networking",
            "speakers": []
          }
        ]
      },
      {
        "day": "Day 2 - October 8, 2025",
        "events": [
          {
            "time": "09:00 AM - 11:00 AM",
            "title": "Workshop: Advancing Decent Work",
            "description": "Interactive session on strategies for inclusive labor markets and social protection.",
            "location": "Room A-1",
            "type": "Workshop",
            "speakers": [
              "Ms. Amina Hassan, Labor Policy Specialist",
              "Mr. Carlos Rivera, Union Representative"
            ]
          },
          {
            "time": "11:30 AM - 01:00 PM",
            "title": "Breakout Session: Gender Equality in the Workplace",
            "description": "Discussion on closing gender gaps and promoting equal opportunities.",
            "location": "Room B-2",
            "type": "Breakout",
            "speakers": [
              "Dr. Elena Martinez, Gender Equality Advocate"
            ]
          },
          {
            "time": "02:00 PM - 04:00 PM",
            "title": "Plenary Session: Climate Resilience and Jobs",
            "description": "Tripartite dialogue on green jobs and sustainable economic transitions.",
            "location": "Grand Ballroom",
            "type": "Plenary",
            "speakers": [
              "Mr. Rajesh Gupta, Environmental Economist",
              "Ms. Sofia Mendes, Climate Policy Advisor"
            ]
          },
          {
            "time": "04:30 PM - 06:00 PM",
            "title": "Networking Reception",
            "description": "Evening reception with drinks and live music for delegates.",
            "location": "Garden Pavilion",
            "type": "Networking",
            "speakers": []
          }
        ]
      },
      {
        "day": "Day 3 - October 9, 2025",
        "events": [
          {
            "time": "09:00 AM - 10:30 AM",
            "title": "Panel: Youth Employment and Skills Development",
            "description": "Addressing youth unemployment through education and training programs.",
            "location": "Room C-3",
            "type": "Panel",
            "speakers": [
              "Ms. Clara Nguyen, Youth Employment Expert",
              "Mr. David Osei, Vocational Training Specialist"
            ]
          },
          {
            "time": "11:00 AM - 12:30 PM",
            "title": "Breakout Session: Informal Economy Transition",
            "description": "Strategies to formalize informal work and ensure worker protections.",
            "location": "Room D-4",
            "type": "Breakout",
            "speakers": [
              "Dr. Samuel Okoro, Labor Economist"
            ]
          },
          {
            "time": "01:30 PM - 03:00 PM",
            "title": "Closing Plenary: Action Plan for the Region",
            "description": "Adoption of key resolutions and closing remarks.",
            "location": "Grand Ballroom",
            "type": "Plenary",
            "speakers": [
              "Gilbert F. Houngbo, ILO Director-General"
            ]
          },
          {
            "time": "03:30 PM - 04:00 PM",
            "title": "Farewell Coffee",
            "description": "Final networking opportunity before departure.",
            "location": "Main Lobby",
            "type": "Networking",
            "speakers": []
          }
        ]
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    // Parse JSON data
    final Map<String, dynamic> agendaData = jsonDecode(agendaJson);
    final List<dynamic> agendaDays = agendaData['agenda'];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6F0FA),
              Color(0xFFD0E8E4),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar with Back Button
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2A7C76)),
                  onPressed: () => Navigator.pop(context),
                ),
                pinned: true,
              ),
              // Agenda Content
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeInLeft(
                      child: Text(
                        "Agenda",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Loop through agenda days
                    ...agendaDays.asMap().entries.map((entry) {
                      int index = entry.key;
                      var day = entry.value;
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2A7C76),
                                      Color(0xFF1A5C56),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  day['day'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Loop through events for each day
                              ...day['events'].asMap().entries.map<Widget>((eventEntry) {
                                int eventIndex = eventEntry.key;
                                var event = eventEntry.value;
                                return FadeInRight(
                                  delay: Duration(milliseconds: 100 * eventIndex),
                                  child: EventCard(
                                    time: event['time'],
                                    title: event['title'],
                                    description: event['description'],
                                    location: event['location'],
                                    type: event['type'],
                                    speakers: List<String>.from(event['speakers']),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16), // Extra padding at the bottom
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  final String time;
  final String title;
  final String description;
  final String location;
  final String type;
  final List<String> speakers;

  const EventCard({
    required this.time,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.speakers,
  });

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Column with Icon
                Container(
                  width: 120,
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFF2A7C76),
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          widget.time,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Event Title and Expand Icon
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Color(0xFF2A7C76),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Color(0xFF2A7C76),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Location: ${widget.location}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 16,
                    color: Color(0xFF2A7C76),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Type: ${widget.type}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2A7C76),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (widget.speakers.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  "Speakers:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                ...widget.speakers.map((speaker) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic,
                          size: 14,
                          color: Color(0xFF2A7C76),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            speaker,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}