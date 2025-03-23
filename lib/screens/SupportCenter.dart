import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SupportCenterApp());
}

class SupportCenterApp extends StatelessWidget {
  const SupportCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SupportHomePage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[850],
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class SupportHomePage extends StatefulWidget {
  const SupportHomePage({super.key});

  @override
  _SupportHomePageState createState() => _SupportHomePageState();
}

class _SupportHomePageState extends State<SupportHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to launch Telegram with bot link (unchanged)
  Future<void> _launchTelegramBot() async {
    const String botUsername = '@MySupportBot'; // Replace with your bot's username
    const String preFilledMessage = 'Hello, I need support!';
    final Uri telegramUrl = Uri.parse(
      'https://t.me/$botUsername?start=${Uri.encodeComponent(preFilledMessage)}',
    );

    if (await canLaunchUrl(telegramUrl)) {
      await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Telegram. Please install it.')),
      );
    }
  }

  // Function to launch WhatsApp with your phone number
  Future<void> _launchWhatsApp() async {
    const String phoneNumber = '+251901084102'; // Replace with your phone number in international format
    const String preFilledMessage = 'Hi, I need support from your app!';
    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(preFilledMessage)}',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening WhatsApp...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp. Please install it.')),
      );
    }
  }

  // Cool dialog for Telegram connection (unchanged)
  void _showTelegramDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BounceInAnimation(
              child: const Icon(
                Icons.telegram,
                size: 60,
                color: Colors.tealAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Connect via Telegram',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap below to chat with our support bot instantly!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _launchTelegramBot();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chat),
              label: const Text('Start Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkModeOn ? Colors.grey[900] : Colors.grey[100],
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.purpleAccent.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Contact & Support",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: white, blurRadius: 10)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: ListView(
                      children: [
                        _buildContactCard(
                          icon: Icons.email_outlined,
                          title: "Email Us",
                          subtitle: "support@example.com",
                          color: Colors.teal,
                          onTap: () {},
                        ),
                        _buildContactCard(
                          icon: Icons.phone_outlined,
                          title: "Call Us",
                          subtitle: "+1 (800) 123-4567",
                          color: Colors.purpleAccent,
                          onTap: () {},
                        ),
                        _buildContactCard(
                          icon: Icons.location_on_outlined,
                          title: "Visit Us",
                          subtitle: "123 Support St, Tech City",
                          color: Colors.blueAccent,
                          onTap: () {},
                        ),
                        _buildContactCard(
                          icon: Icons.chat_bubble_outline,
                          title: "Live Support",
                          subtitle: "Available 24/7",
                          color: Colors.orangeAccent,
                          onTap: _showTelegramDialog,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: AnimatedScale(
              scale: 1.0 + (_controller.value * 0.1),
              duration: const Duration(milliseconds: 1000),
              child: FloatingActionButton(
                onPressed: _launchWhatsApp, // Connect to WhatsApp on tap
                backgroundColor: Colors.tealAccent,
                child: const Icon(Icons.support_agent, size: 32, color: Colors.black87),
                elevation: 15,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom BounceInAnimation widget (unchanged)
class BounceInAnimation extends StatefulWidget {
  final Widget child;

  const BounceInAnimation({super.key, required this.child});

  @override
  _BounceInAnimationState createState() => _BounceInAnimationState();
}

class _BounceInAnimationState extends State<BounceInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}