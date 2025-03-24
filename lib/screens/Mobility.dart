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
    {
      'title': 'Hotel',
      'icon': Icons.hotel,
      'color': Colors.red,
      'description': 'Affordable lodging options for immigrants.',
    },
    {
      'title': 'Embassy',
      'icon': Icons.account_balance,
      'color': Colors.teal,
      'description': 'Embassy contacts for visa and support.',
    },
    {
      'title': 'Health',
      'icon': Icons.local_hospital,
      'color': Colors.pink,
      'description': 'Healthcare services and emergency contacts.',
    },
    {
      'title': 'Jobs',
      'icon': Icons.work,
      'color': Colors.indigo,
      'description': 'Job opportunities and resources for immigrants.',
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
              icon: widget.icon,
            ),
          ),
        );
      },
      onLongPress: () => _showPhoneInputDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0), // Should be bottom: 10.0
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
  final IconData icon;

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
Our airport transfer services provide reliable transportation to and from major airports across Ethiopia, ideal for immigrants arriving in the country.

Features:
• 24/7 availability at major airports
• Professional drivers with local knowledge
• Modern vehicles with air conditioning
• Real-time flight tracking
• Meet and greet service for new arrivals

Major Airports Served:
1. Addis Ababa Bole International Airport (ADD)
   - Largest hub in Ethiopia
   - Multiple daily transfers
   - Immigrant assistance desk
2. Bahir Dar Airport (BJR)
   - Serving northern Ethiopia
   - Scenic route options
3. Dire Dawa International Airport (DIR)
   - Eastern Ethiopia gateway

Pricing:
• Starting at 25 USD for standard transfers
• Premium options available from 50 USD
• Group rates for families or groups

Booking Options:
• Pre-book through our app
• On-arrival booking at airport counters
• Phone reservation system: +251-911-123-456
''';
      case 'bus':
        return '''
Bus Transportation Services in Ethiopia

Overview:
Our bus services connect major cities and towns, offering an affordable travel option for immigrants exploring or settling in Ethiopia.

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
• Immigrant-friendly staff available
''';
      case 'taxi':
        return '''
Taxi Services in Ethiopia

Overview:
Our taxi services offer convenient urban and intercity transportation, perfect for immigrants navigating new cities.

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
• GPS tracking for route assistance
''';
      case 'call':
        return '''
Call Center Services

Overview:
Our dedicated call center provides comprehensive support for immigrants with transportation and settlement needs in Ethiopia.

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
3. Immigrant Hotline: +251-911-456-789
   - Hours: 6 AM - 10 PM

Features:
• Multi-language support (Amharic, English, Arabic, more)
• Trained representatives for immigrant queries
• Quick response times
• Complaint resolution system
• Travel advisory updates

Additional Services:
• SMS confirmation for bookings
• Email support: support@mobilityhub.et
• Live chat through our website
''';
      case 'hotel':
        return '''
Hotel and Accommodation Services

Overview:
Affordable and safe lodging options for immigrants settling in Ethiopia, ranging from budget stays to mid-range hotels.

Options:
1. Budget Hotels
   - Price: 10-20 USD per night
   - Basic amenities (bed, Wi-Fi, water)
   - Locations: Addis Ababa, Dire Dawa
2. Mid-Range Hotels
   - Price: 25-50 USD per night
   - Includes breakfast, air conditioning
   - Locations: Major cities
3. Long-Term Stays
   - Monthly rates from 200 USD
   - Furnished rooms with kitchenette

Popular Choices:
• Harmony Hotel, Addis Ababa
   - Near Bole Airport
   - Immigrant-friendly staff
• Selam Hotel, Bahir Dar
   - Lake view rooms
• Dire Dawa Guesthouse
   - Budget option near airport

Booking:
• Call: +251-911-555-123
• App: Mobility Hub app
• Walk-in available

Tips for Immigrants:
• Ask for weekly/monthly discounts
• Verify proximity to public transport
• Carry ID for check-in
''';
      case 'embassy':
        return '''
Embassy and Consulate Services

Overview:
Key embassy contacts for immigrants needing visa support, documentation, or emergency assistance in Ethiopia.

Major Embassies in Addis Ababa:
1. U.S. Embassy
   - Address: Entoto Street, Addis Ababa
   - Phone: +251-111-306-000
   - Services: Visa renewals, citizen services
2. UK Embassy
   - Address: Comoros St, Addis Ababa
   - Phone: +251-116-170-100
   - Services: Passports, emergency travel
3. EU Delegation
   - Address: Cape Verde St, Addis Ababa
   - Phone: +251-116-612-511
   - Services: Schengen visa info

Other Embassies:
• Somali Embassy: +251-911-222-333
• Eritrean Embassy: +251-911-444-555
• Sudanese Embassy: +251-911-666-777

Services:
• Visa extensions
• Lost passport replacement
• Emergency repatriation
• Legal assistance referrals

Tips for Immigrants:
• Book appointments online where possible
• Bring all immigration documents
• Contact in advance for emergencies
''';
      case 'health':
        return '''
Healthcare Services

Overview:
Access to medical facilities and emergency services for immigrants in Ethiopia.

Key Hospitals:
1. St. Paul’s Hospital, Addis Ababa
   - Address: Swaziland St
   - Phone: +251-112-757-011
   - Services: General care, emergencies
2. Hawassa University Hospital
   - Phone: +251-462-205-311
   - Services: Affordable treatment
3. Bahir Dar Felege Hiwot Hospital
   - Phone: +251-582-207-811

Emergency Numbers:
• Ambulance: 911 or +251-911-999-000
• Medical Hotline: +251-911-888-111

Services:
• Free clinics for basic care
• Vaccination programs
• Maternal and child health
• Pharmacy locator

Tips for Immigrants:
• Carry health insurance if possible
• Register with local clinics
• Learn basic Amharic medical terms
''';
      case 'jobs':
        return '''
Job Opportunities for Immigrants

Overview:
Resources and opportunities for immigrants seeking employment in Ethiopia.

Job Sectors:
1. Agriculture
   - Roles: Farm workers, supervisors
   - Pay: 50-100 USD/month
2. Construction
   - Roles: Laborers, skilled trades
   - Pay: 80-150 USD/month
3. Hospitality
   - Roles: Hotel staff, guides
   - Pay: 60-120 USD/month

Resources:
• Ethiojobs.net
   - Online job portal
   - Register for free
• Refugee Job Center, Addis Ababa
   - Phone: +251-911-777-222
   - Walk-in support
• UN Migration Agency (IOM)
   - Phone: +251-116-611-111

Tips for Immigrants:
• Learn basic Amharic for better opportunities
• Bring translated work certificates
• Network at community centers
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
                            icon,
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