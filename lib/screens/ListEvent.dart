import 'package:event_prokit/utils/EAColors.dart';
import 'package:flutter/material.dart';

class ListEvent extends StatelessWidget {
  // Conference-themed event items with concise data
  final List<Map<String, dynamic>> eventItems = [
    {
      'title': 'Programme',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
    },
    {
      'title': 'Agenda',
      'icon': Icons.event,
      'color': Colors.green,
    },
    {
      'title': 'Keynotes',
      'icon': Icons.star,
      'color': Colors.purple,
    },
    {
      'title': 'Speakers',
      'icon': Icons.mic,
      'color': Colors.orange,
    },
    {
      'title': 'Tech',
      'icon': Icons.code,
      'color': Colors.teal,
    },
    {
      'title': 'Media',
      'icon': Icons.photo_camera,
      'color': Colors.pink,
    },
    {
      'title': 'Exhibits',
      'icon': Icons.store,
      'color': Colors.red,
    },
    {
      'title': 'Demos',
      'icon': Icons.play_circle_filled,
      'color': Colors.cyan,
    },
    {
      'title': 'Guide',
      'icon': Icons.help,
      'color': Colors.indigo,
    },
    {
      'title': 'Support',
      'icon': Icons.support_agent,
      'color': Colors.grey,
    },
    {
      'title': 'Attendees',
      'icon': Icons.people,
      'color': Colors.amber,
    },
    {
      'title': 'Workshops',
      'icon': Icons.build,
      'color': Colors.deepPurple,
    },
    {
      'title': 'Networking',
      'icon': Icons.connect_without_contact,
      'color': Colors.deepOrange,
    },
    {
      'title': 'Map',
      'icon': Icons.map,
      'color': Colors.blueGrey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Group items into pairs
    List<List<Map<String, dynamic>>> pairedItems = [];
    for (int i = 0; i < eventItems.length; i += 2) {
      pairedItems.add(
        eventItems.sublist(i, i + 2 > eventItems.length ? eventItems.length : i + 2),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: pairedItems.map((pair) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0), // Space between rows
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: EventCard(
                        title: pair[0]['title'],
                        icon: pair[0]['icon'],
                        color: pair[0]['color'],
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${pair[0]['title']} pressed')),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12), // Space between cards in a pair
                    if (pair.length > 1)
                      Expanded(
                        child: EventCard(
                          title: pair[1]['title'],
                          icon: pair[1]['icon'],
                          color: pair[1]['color'],
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${pair[1]['title']} pressed')),
                            );
                          },
                        ),
                      )
                    else
                      Expanded(child: SizedBox()), // Placeholder for odd number
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Custom EventCard widget for a sleek, compact design
class EventCard extends StatefulWidget {
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
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 100, // Compact height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.9),
                    widget.color.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Subtle background overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        // Title
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(1, 1),
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
                  // Ripple effect
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.1),
                        onTap: () {}, // Handled by GestureDetector
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}