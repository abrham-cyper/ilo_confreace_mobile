import 'package:flutter/material.dart';
 

class SupportCenterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SupportHomePage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class SupportHomePage extends StatefulWidget {
  @override
  _SupportHomePageState createState() => _SupportHomePageState();
}

class _SupportHomePageState extends State<SupportHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Header
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
          // Main Content with Fade Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Contact & Support",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Contact Information Section
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Action Button with Pulse Animation
          Positioned(
            bottom: 30,
            right: 30,
            child: AnimatedScale(
              scale: 1.0 + (_controller.value * 0.1),
              duration: Duration(milliseconds: 1000),
              child: FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Opening Support Chat...")),
                  );
                },
                backgroundColor: Colors.tealAccent,
                child: Icon(Icons.support_agent, size: 32, color: Colors.black87),
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
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: 1.0,
              duration: Duration(milliseconds: 200),
              child: Icon(icon, size: 40, color: color),
            ),
            SizedBox(width: 20),
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
                SizedBox(height: 5),
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