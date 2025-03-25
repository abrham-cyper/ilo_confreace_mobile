import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:event_prokit/screens/AgendaScreen.dart';
import 'package:event_prokit/screens/AttendeesApp.dart';
import 'package:event_prokit/screens/BadgeBottomSheet.dart';
import 'package:event_prokit/screens/Booking.dart';
import 'package:event_prokit/screens/CongressPartners.dart';
import 'package:event_prokit/screens/EventDetailPage.dart';
import 'package:event_prokit/screens/AgendaPage.dart';
import 'package:event_prokit/screens/Floormap.dart';
import 'package:event_prokit/screens/Mobility.dart';
import 'package:event_prokit/screens/HighLevelProgramPage.dart';
import 'package:event_prokit/screens/MediaPage.dart';
import 'package:event_prokit/screens/Program.dart';
import 'package:event_prokit/screens/Speakers.dart';
import 'package:event_prokit/screens/SupportCenter.dart';
import 'package:event_prokit/main.dart'; // Import main.dart for appStore
import 'package:flutter_mobx/flutter_mobx.dart'; // Import flutter_mobx for Observer

class ListEvent extends StatefulWidget {
  @override
  _ListEventState createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent> {
  List<Map<String, dynamic>> eventItems = [];
  late VideoPlayerController _videoController;

  // Define a single primary color
  static const Color primaryColor1 = Colors.green; // You can change this to any color

  @override
  void initState() {
    super.initState();
    fetchEventItems();
    _videoController = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/13192/13192-720.mp4',
    )..initialize().then((_) {
        setState(() {
          _videoController.play();
        });
      });
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> fetchEventItems() async {
    const url = '${AppConstants.baseUrl}/api/cards';
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('No access token found. User may not be logged in.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to view events')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          eventItems = (data['data'] as List).map((item) {
            return {
              'title': item['name'],
              'icon': _getIconForEvent(item['name']),
              'color': primaryColor1, // Use the single primary color
              '_id': item['_id'],
            };
          }).toList();
          if (!eventItems.any((item) => item['title'] == 'My Badge')) {
            eventItems.add({
              'title': 'My Badge',
              'icon': Icons.badge,
              'color': primaryColor1, // Use the single primary color
              '_id': 'my_badge_id',
            });
          }
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  IconData _getIconForEvent(String name) {
    switch (name) {
      case 'Programme Overview':
        return Icons.calendar_today;
      case 'Agenda':
        return Icons.schedule;
      case 'High Level Program':
        return Icons.star;
      case 'Speakers':
        return Icons.mic;
      case 'Media':
        return Icons.photo;
      case 'Mobility':
        return Icons.store;
      case 'Demos':
        return Icons.play_circle_outline;
      case 'Guide':
        return Icons.help;
      case 'Support':
        return Icons.support_agent;
      case 'Attendees':
        return Icons.people;
      case 'Workshops':
        return Icons.build;
      case 'Networking':
        return Icons.connect_without_contact;
      case 'Map':
        return Icons.map;
      case 'My Badge':
        return Icons.badge;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, dynamic>>> pairedItems = [];
    for (int i = 0; i < eventItems.length; i += 2) {
      pairedItems.add(
        eventItems.sublist(i, i + 2 > eventItems.length ? eventItems.length : i + 2),
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.isDarkModeOn
            ? Colors.grey[900]
            : Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _videoController.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: pairedItems.map((pair) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0), // Fix this typo later
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: EventCard(
                              title: pair[0]['title'],
                              icon: pair[0]['icon'],
                              color: pair[0]['color'],
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('event_id', pair[0]['_id']);
                                _navigateToPage(context, pair[0]['title']);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (pair.length > 1)
                            Expanded(
                              child: EventCard(
                                title: pair[1]['title'],
                                icon: pair[1]['icon'],
                                color: pair[1]['color'],
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('event_id', pair[1]['_id']);
                                  _navigateToPage(context, pair[1]['title']);
                                },
                              ),
                            )
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, String title) {
    if (title == 'My Badge') {
      _showBadgeBottomSheet(context);
    } else {
      Widget page;
      switch (title) {
        case 'Programme overview':
          page = Program();
          break;
        case 'Floormap':
          page = Floormap();
          break;
        case 'Attendees':
          page = AttendeesApp();
          break;
        case 'Your Ticket':
          page = UserListScreen(); // Assuming this is defined elsewhere
          break;
        case 'Agenda':
          page = AgendaScreen();
          break;
        case 'High Level Program':
          page = HighLevelProgramPage();
          break;
        case 'Speakers':
          page = SpeakersScreen();
          break;
        case 'Media':
          page = ConferenceFeedScreen(); // Assuming this is defined elsewhere
          break;
        case 'Mobility':
          page = Mobility();
          break;
        case 'Support':
          page = SupportCenterApp();
          break;
        case 'Congress Partners':
          page = CongressPartnersScreen();
          break;
        default:
          page = EventDetailPage();
          break;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  void _showBadgeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BadgeBottomSheet(),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const EventCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}