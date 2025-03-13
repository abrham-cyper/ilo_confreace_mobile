import 'package:event_prokit/utils/EAColors.dart';
import 'package:flutter/material.dart';

class ListEvent extends StatelessWidget {
  // Updated list of button titles
  final List<String> buttonTitles = [
    'Programme Overview',
    'My Agenda',
    'High Level Program',
    'Speakers',
    'Technical Program',
    'Photo and Video Library',
    'Exhibitors',
    'Demonstration',
    'How to Use the App',
    'Support Center',
    'Attendees',
    'Event 12', // Placeholder for remaining items (you can replace these)
    'Event 13',
    'Event 14',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 buttons per row
            crossAxisSpacing: 16, // Horizontal spacing between buttons
            mainAxisSpacing: 16, // Vertical spacing between rows
            childAspectRatio: 1.5, // Aspect ratio of buttons (width/height)
          ),
          itemCount: buttonTitles.length, // Total 14 buttons
          itemBuilder: (context, index) {
            return EventButton(
              title: buttonTitles[index],
              onPressed: () {
                // Handle button press (add your logic here)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${buttonTitles[index]} pressed')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Custom EventButton widget for reusable button styling
class EventButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;

  const EventButton({required this.title, required this.onPressed});

  @override
  _EventButtonState createState() => _EventButtonState();
}

class _EventButtonState extends State<EventButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100), // Fast animation for quick feedback
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
      onTapDown: (_) => _animationController.forward(), // Scale down on press
      onTapUp: (_) => _animationController.reverse(), // Scale back on release
      onTapCancel: () => _animationController.reverse(), // Scale back if canceled
      onTap: widget.onPressed, // Trigger the onPressed callback
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value, // Apply scaling animation
            child: child,
          );
        },
        child: ElevatedButton(
          onPressed: widget.onPressed, // Required for ripple effect
          style: ElevatedButton.styleFrom(
            foregroundColor: primaryColor1, // Text/icon color
            backgroundColor: Colors.white, // Button background color
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Increased for "light cool" look
              side: BorderSide(
                color: primaryColor1.withOpacity(0.7), // Slightly lighter border
                width: 2, // Border width
              ),
            ),
            elevation: 6, // Shadow elevation
            shadowColor: Colors.black.withOpacity(0.3), // Shadow color
            splashFactory: InkRipple.splashFactory, // Enables ripple effect
            // Fixed: Correctly wrap the overlayColor in MaterialStateProperty
            // overlayColor: WidgetStateProperty.all(primaryColor1.withOpacity(0.2)), // Ripple color
          ),
          child: Text(
            widget.title,
            textAlign: TextAlign.center, // Center the text horizontally
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor1, // Text color
            ),
          ),
        ),
      ),
    );
  }
}