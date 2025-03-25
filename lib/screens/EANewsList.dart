import 'package:event_prokit/screens/BecomePartener.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model for EAEventList with additional fields
class EAEventList {
  final String? id;
  final String name;
  final String date;
  final String image;
  final String? about;
  final int cost;
  final String exhibitionBooth;
  final int vipPasses;
  final int delegatePasses;
  final int galaDinnerInvitations;
  final String advertOnMaterials;
  final String websiteAdvertisement;
  final String type;

  EAEventList({
    this.id,
    required this.name,
    required this.date,
    required this.image,
    this.about,
    required this.cost,
    required this.exhibitionBooth,
    required this.vipPasses,
    required this.delegatePasses,
    required this.galaDinnerInvitations,
    required this.advertOnMaterials,
    required this.websiteAdvertisement,
    required this.type,
  });

  factory EAEventList.fromJson(Map<String, dynamic> json) {
    return EAEventList(
      id: json['_id'],
      name: json['name'],
      date: json['date'],
      image: json['image'],
      about: json['about'],
      cost: json['cost'],
      exhibitionBooth: json['exhibitionBooth'],
      vipPasses: json['vipPasses'],
      delegatePasses: json['delegatePasses'],
      galaDinnerInvitations: json['galaDinnerInvitations'],
      advertOnMaterials: json['advertOnMaterials'],
      websiteAdvertisement: json['websiteAdvertisement'],
      type: json['type'] ?? 'unknown',
    );
  }
}

// Main widget
class EANewsList extends StatefulWidget {
  @override
  _EANewsListState createState() => _EANewsListState();
}

class _EANewsListState extends State<EANewsList> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  List<EAEventList> eventList = [];
  List<EAEventList> allPartners = [];
  bool isLoading = true;
  String? selectedType;

  final List<String> imageList = [
    "https://i.pinimg.com/736x/65/56/ee/6556eedae5d32a12661d0895760c826b.jpg",
  ];

  final String brochureUrl = "https://iloethiopia2025.gov.et/storage/2024/12/Int_Dev_Par.pdf";

  @override
  void initState() {
    super.initState();
    init();
    fetchPartners();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  Future<void> fetchPartners() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('No access token found. User may not be logged in.');
        toast('Please log in to view partners');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/partners'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final partners = (jsonData['data'] as List)
            .map((item) => EAEventList.fromJson(item))
            .toList();
        setState(() {
          allPartners = partners;
          eventList = partners;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load partners: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching partners: $e');
      setState(() {
        isLoading = false;
      });
      toast('Failed to load data from server');
    }
  }

  void filterByType(String? type) {
    setState(() {
      selectedType = type;
      if (type == null) {
        eventList = List.from(allPartners);
      } else {
        eventList = allPartners.where((partner) => partner.type == type).toList();
      }
    });
  }

  Future<void> _launchBrochureUrl() async {
    final Uri uri = Uri.parse(brochureUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      toast('Could not launch brochure URL');
    }
  }

  Future<void> _savePackageToPrefs(String packageName, String? partnerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_package', packageName);
    if (partnerId != null) {
      await prefs.setString('packageid', partnerId);
    } else {
      await prefs.remove('packageid');
    }
    print('Saved package: $packageName');
    print('Saved package ID: $partnerId');
    toast('Package $packageName saved successfully');
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueTypes = allPartners.map((e) => e.type).toSet().toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 380.0,
              forceElevated: innerBoxIsScrolled,
              title: Text(
                innerBoxIsScrolled ? "Become a Partner" : "",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor1,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: imageList.length,
                      itemBuilder: (context, i) {
                        return Image.network(
                          imageList[i],
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (value) {
                        setState(() => currentIndexPage = value);
                      },
                    ),
                    Positioned(
                      top: 30,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          _launchBrochureUrl();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Brochure",
                              style: boldTextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.download, color: Colors.white, size: 48),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Partner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Partner with the 2025 ILO Regional Conference to boost visibility, connect with leaders, and shape the future of work.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 12,
                      right: 12,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Removed the "All" button
                            ...uniqueTypes.map((type) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(
                                  type,
                                  style: TextStyle(
                                    color: selectedType == type ? Colors.white : Colors.black,
                                  ),
                                ),
                                selected: selectedType == type,
                                selectedColor: Colors.black,
                                backgroundColor: Colors.grey.withOpacity(0.7),
                                onSelected: (selected) {
                                  if (selected) filterByType(type);
                                },
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          imageList.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndexPage == index ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : eventList.isEmpty
                ? Center(child: Text('No partners found for this type'))
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(12),
                    itemCount: eventList.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                eventList[i].image,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ).cornerRadiusWithClipRRect(8),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(eventList[i].name, style: boldTextStyle(size: 18)),
                                    SizedBox(height: 8),
                                    Text(eventList[i].date, style: secondaryTextStyle()),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$${eventList[i].cost.toString()}',
                                      style: boldTextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).onTap(
                        () async {
                          await _savePackageToPrefs(eventList[i].name, eventList[i].id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EANewsDetailScreen(event: eventList[i]),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

class EANewsDetailScreen extends StatelessWidget {
  final EAEventList event;

  const EANewsDetailScreen({required this.event, super.key});

  Future<void> _savePackageToPrefs(String packageName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_package', packageName);
    print('Saved package: $packageName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEventImage(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventHeader(),
                      const SizedBox(height: 20),
                      if (event.about != null) _buildAboutSection(),
                      const SizedBox(height: 20),
                      _buildDetailsSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildPersistentApplyButton(context),
        ],
      ),
    );
  }

  Widget _buildEventImage(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            event.image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildEventHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: primaryColor1),
            const SizedBox(width: 8),
            Text(
              event.date,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Text(
        event.about!,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          _buildDetailRow("Cost", "\$${event.cost}", Icons.attach_money),
          _buildDetailRow("Exhibition Booth", event.exhibitionBooth, Icons.store),
          _buildDetailRow("VIP Passes", event.vipPasses.toString(), Icons.star),
          _buildDetailRow("Delegate Passes", event.delegatePasses.toString(), Icons.group),
          _buildDetailRow("Gala Dinner Invitations", event.galaDinnerInvitations.toString(), Icons.dinner_dining),
          _buildDetailRow("Advertisement ", event.advertOnMaterials, Icons.print),
          _buildDetailRow("Website", event.websiteAdvertisement, Icons.web),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: primaryColor1),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: primaryColor1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentApplyButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () async {
            await _savePackageToPrefs(event.name);
            await Future.delayed(const Duration(milliseconds: 300));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BecomePartener()),
            );
          },
          icon: const Icon(Icons.check_circle_outline, size: 24),
          label: const Text(
            "Apply Now",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: white,
            backgroundColor: primaryColor1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
    );
  }
}