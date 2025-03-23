import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(home: Mobility()));
}

class Mobility extends StatefulWidget {
  const Mobility({super.key});

  @override
  _MobilityState createState() => _MobilityState();
}

class _MobilityState extends State<Mobility> {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Airport',
      'icon': Icons.flight,
      'color': Colors.blue,
      'description': 'Reliable airport transfers across Ethiopia.',
    },
    {
      'title': 'Bus',
      'icon': Icons.directions_bus,
      'color': Colors.green,
      'description': 'Connects major cities with modern buses.',
    },
    {
      'title': 'Taxi',
      'icon': Icons.local_taxi,
      'color': Colors.orange,
      'description': 'Convenient urban and intercity taxi services.',
    },
    {
      'title': 'Call',
      'icon': Icons.phone,
      'color': Colors.purple,
      'description': '24/7 support for all transport needs.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mobility Hub',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Services List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(
                    title: service['title'],
                    icon: service['icon'],
                    color: service['color'],
                    description: service['description'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const ServiceCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Add Phone for ${widget.title}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        content: TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.poppins(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter Phone Number',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addPhoneNumber();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
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
              color: widget.color,
              icon: widget.icon, // Pass the icon to ServiceDetailPage
            ),
          ),
        );
      },
      onLongPress: () => _showPhoneInputDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0), // Gap between cards
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                size: 30,
                color: widget.color,
              ),
            ),
            const SizedBox(width: 12),
            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_phoneNumbers.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: _phoneNumbers
                          .asMap()
                          .entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () => _removePhoneNumber(entry.key),
                              child: Chip(
                                label: Text(
                                  entry.value,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                backgroundColor: widget.color,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceDetailPage extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon; // Added icon parameter

  const ServiceDetailPage({
    required this.title,
    required this.color,
    required this.icon,
  });

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$title Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon, // Use the passed icon
                            size: 24,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      getDetailedInfo(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
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