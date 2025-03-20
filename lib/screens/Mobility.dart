import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(home: Mobility()));
}

class Mobility extends StatelessWidget {
  const Mobility({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobility Hub',
                    style: GoogleFonts.orbitron(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Gateway to Ethiopia’s Transport',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2F),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'General Information',
                          style: GoogleFonts.orbitron(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '• Operating Hours: 24/7\n'
                          '• Customer Support: +251-911-123-456\n'
                          '• Payment Methods: Cash, Mobile Money, Card\n'
                          '• Coverage: Major Ethiopian Cities\n'
                          '• Booking: App, Website, or Call Center',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.85,
                      children: [
                        CircularServiceCard(
                          title: 'Airport',
                          icon: Icons.flight,
                          glowColor: Colors.cyan,
                        ),
                        CircularServiceCard(
                          title: 'Bus',
                          icon: Icons.directions_bus,
                          glowColor: Colors.greenAccent,
                        ),
                        CircularServiceCard(
                          title: 'Taxi',
                          icon: Icons.local_taxi,
                          glowColor: Colors.yellowAccent,
                        ),
                        CircularServiceCard(
                          title: 'Call',
                          icon: Icons.phone,
                          glowColor: Colors.purpleAccent,
                        ),
                      ],
                    ),
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

// New Service Detail Page
class ServiceDetailPage extends StatelessWidget {
  final String title;
  final Color glowColor;

  const ServiceDetailPage({super.key, required this.title, required this.glowColor});

  String getDetailedInfo() {
    switch (title.toLowerCase()) {
      case 'airport':
        return '''
Airport Transfer Services in Ethiopia

Overview:
Our airport transfer services provide reliable transportation to and from major airports across Ethiopia. We ensure comfortable and timely transfers for both domestic and international travelers.

Features:
• 24/7 availability at major airports
• Professional drivers with local knowledge
• Modern vehicles with air conditioning
• Real-time flight tracking
• Meet and greet service

Major Airports Served:
1. Addis Ababa Bole International Airport (ADD)
   - Largest hub in Ethiopia
   - Multiple daily transfers
   - VIP lounge access available
2. Bahir Dar Airport (BJR)
   - Serving northern Ethiopia
   - Scenic route options
3. Dire Dawa International Airport (DIR)
   - Eastern Ethiopia gateway

Pricing:
• Starting at 25 USD for standard transfers
• Premium options available from 50 USD
• Group rates available

Booking Options:
• Pre-book through our app
• On-arrival booking at airport counters
• Phone reservation system
''';
      case 'bus':
        return '''
Bus Transportation Services in Ethiopia

Overview:
Our bus services connect major cities and towns across Ethiopia with a modern fleet of vehicles designed for comfort and safety.

Features:
• Daily scheduled departures
• Comfortable seating with ample legroom
• Onboard refreshments on select routes
• Luggage storage included
• Wi-Fi on premium buses

Popular Routes:
1. Addis Ababa to Bahir Dar
   - 9-hour journey
   - Scenic views of Blue Nile
   - Multiple daily departures
2. Addis Ababa to Hawassa
   - 5-hour journey
   - Lake views en route
3. Addis Ababa to Mekelle
   - Northern route option

Pricing:
• Standard tickets from 15 USD
• Premium seats from 25 USD
• Children under 5 travel free

Terminals:
• Main terminal at Meskel Square, Addis Ababa
• Regional terminals in major cities
''';
      case 'taxi':
        return '''
Taxi Services in Ethiopia

Overview:
Our taxi services offer convenient urban and intercity transportation with a fleet of well-maintained vehicles and professional drivers.

Features:
• Instant booking via app
• Metered fares with transparent pricing
• Available 24/7 in major cities
• Choice of vehicle types
• Child seats available on request

Service Types:
1. Standard Taxi
   - Base fare: 2 USD
   - 0.5 USD per km
   - Ideal for short trips
2. Premium Taxi
   - Base fare: 5 USD
   - 1 USD per km
   - Luxury vehicles
3. Airport Shuttle
   - Flat rates to/from airports

Coverage Areas:
• Addis Ababa metropolitan area
• Regional cities including Hawassa, Bahir Dar
• Special long-distance options

Safety:
• All drivers background-checked
• Vehicles regularly inspected
• GPS tracking
''';
      case 'call':
        return '''
Call Center Services

Overview:
Our dedicated call center provides comprehensive support for all your transportation needs in Ethiopia.

Services:
• Booking assistance for all transport types
• Real-time travel information
• Customer support and inquiries
• Emergency assistance
• Lost and found services

Contact Numbers:
1. General Inquiries: +251-911-123-456
   - Hours: 8 AM - 8 PM
2. Emergency Line: +251-911-789-012
   - Available: 24/7
3. Booking Hotline: +251-911-456-789
   - Hours: 6 AM - 10 PM

Features:
• Multi-language support (Amharic, English, more)
• Trained customer service representatives
• Quick response times
• Complaint resolution system
• Travel advisory updates

Additional Services:
• SMS confirmation for bookings
• Email support: support@mobilityhub.et
• Live chat through our website
''';
      default:
        return 'No information available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '$title Services',
          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2F),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  getDetailedInfo(),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularServiceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color glowColor;

  const CircularServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.glowColor,
  });

  @override
  _CircularServiceCardState createState() => _CircularServiceCardState();
}

class _CircularServiceCardState extends State<CircularServiceCard> {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> _phoneNumbers = [];

  void _addPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _phoneNumbers.add(_phoneController.text);
        _phoneController.clear();
      });
    }
  }

  void _removePhoneNumber(int index) {
    setState(() {
      _phoneNumbers.removeAt(index);
    });
  }

  void _showPhoneInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Phone for ${widget.title}',
          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20),
        ),
        content: TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.roboto(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter Phone Number',
            hintStyle: GoogleFonts.roboto(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2A2A3D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.roboto(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              _addPhoneNumber();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.glowColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Add', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(
              title: widget.title,
              glowColor: widget.glowColor,
            ),
          ),
        );
      },
      onLongPress: () => _showPhoneInputDialog(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1E1E2F),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 40, color: widget.glowColor),
            const SizedBox(height: 5),
            Text(
              widget.title,
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            if (_phoneNumbers.isNotEmpty) ...[
              const SizedBox(height: 5),
              SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    alignment: WrapAlignment.center,
                    children: _phoneNumbers
                        .asMap()
                        .entries
                        .map(
                          (entry) => GestureDetector(
                            onTap: () => _removePhoneNumber(entry.key),
                            child: Chip(
                              label: Text(
                                entry.value,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: widget.glowColor.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}