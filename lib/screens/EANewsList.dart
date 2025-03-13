import 'package:event_prokit/screens/BecomePartener.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';

// Model for EAEventList
class EAEventList {
  final String? id;
  final String name;
  final String date;
  final String image;
  final String? about;

  EAEventList({
    this.id,
    required this.name,
    required this.date,
    required this.image,
    this.about,
  });

  factory EAEventList.fromJson(Map<String, dynamic> json) {
    return EAEventList(
      id: json['_id'],
      name: json['name'],
      date: json['date'],
      image: json['image'],
      about: json['about'],
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
  bool isLoading = true;

  // Dummy data for PageView (replace with your actual imageList if available)
  final List<String> imageList = [
    "https://preview.redd.it/how-do-you-guys-feel-about-the-adwa-museum-v0-nzaq1atmg0ic1.jpeg?auto=webp&s=7a8a7fe63d8678e7dba82b1e4d7b8d9e686b15da",
  ];

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
      final response = await http.get(Uri.parse('http://192.168.43.25:3000/api/partners'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final partners = (jsonData['data'] as List)
            .map((item) => EAEventList.fromJson(item))
            .toList();
        setState(() {
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 300.0,
              forceElevated: innerBoxIsScrolled,
              title: Text(
                innerBoxIsScrolled ? "Fashions Finest AW18 During New York Fashion Week" : "",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor1, // Replace with EAColors.primaryColor1
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BecomePartener(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Become a Partner",
                              style: boldTextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.add, color: Colors.white, size: 48),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a partner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Partner with the 2025 ILO Regional Conference and play a key role in this influential event',
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
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 12, right: 12, top: 8),
                itemCount: eventList.length,
                itemBuilder: (context, i) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        eventList[i].image,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      ).cornerRadiusWithClipRRect(8),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eventList[i].name, style: boldTextStyle()),
                            SizedBox(height: 20),
                            Text(eventList[i].date, style: secondaryTextStyle()),
                          ],
                        ),
                      ),
                    ],
                  ).onTap(
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EANewsDetailScreen(event: eventList[i]),
                        ),
                      );
                    },
                  ).paddingSymmetric(vertical: 8);
                },
              ),
      ),
    );
  }
}

// Detail Screen
class EANewsDetailScreen extends StatelessWidget {
  final EAEventList event;

  const EANewsDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name, style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor1, // Replace with EAColors.primaryColor1
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(8),
            SizedBox(height: 16),
            Text(event.name, style: boldTextStyle(size: 24)),
            SizedBox(height: 8),
            Text(event.date, style: secondaryTextStyle()),
            if (event.about != null) ...[
              SizedBox(height: 16),
              Text(event.about!, style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
