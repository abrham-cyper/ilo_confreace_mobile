import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/utils/EAImages.dart';
import 'package:event_prokit/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'EAReviewScreen.dart';
import 'EATicketDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EAEventDetailScreen2 extends StatefulWidget {
  final String? name;
  final String? hashTag;
  final String? attending;
  final String? price;
  final String? image;
  final String? detail;

  EAEventDetailScreen2({this.name, this.hashTag, this.attending, this.price, this.image, this.detail});

  @override
  _EAEventDetailScreen2State createState() => _EAEventDetailScreen2State();
}

class _EAEventDetailScreen2State extends State<EAEventDetailScreen2> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  bool fev = false; // Tracks if the event is liked or not
  String? creatorFullname; // To store the event creator's fullname
  Map<String, String> commenterNames = {}; // Map to store commenter ID -> Fullname

  @override
  void initState() {
    super.initState();
    _checkInitialLikeStatus();
    _fetchCreatorFullname();
    _fetchCommenterNames(); // Fetch commenter names when the screen initializes
  }

  // Function to fetch eventId and userId from SharedPreferences
  Future<Map<String, String?>> _getIdsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getString('event_id');
    final userId = prefs.getString('user_id');
    print("Retrieved event_id: $eventId, user_id: $userId");
    return {'eventId': eventId, 'userId': userId};
  }

  // Function to fetch the creator's fullname
  Future<void> _fetchCreatorFullname() async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];

      if (eventId == null) {
        print("No event ID found, skipping creator fetch");
        setState(() {
          creatorFullname = 'Unknown';
        });
        return;
      }

      // Fetch event details to get creator ID
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/news/$eventId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final eventData = jsonDecode(response.body);
        String? creatorId = eventData['creatorId'] ?? eventData['userId']; // Adjust based on your API

        if (creatorId != null) {
          final userResponse = await http.get(
            Uri.parse('${AppConstants.baseUrl}/api/user/userid/$creatorId'),
          );
          if (userResponse.statusCode == 200) {
            final userData = jsonDecode(userResponse.body);
            setState(() {
              creatorFullname = userData['user']['fullname'] ?? 'Unknown';
            });
            print("Creator Fullname: $creatorFullname");
          } else {
            setState(() {
              creatorFullname = 'Unknown';
            });
            print("Failed to fetch user: ${userResponse.statusCode}");
          }
        } else {
          setState(() {
            creatorFullname = 'Unknown';
          });
          print("No creator ID found in event data");
        }
      } else {
        setState(() {
          creatorFullname = 'Unknown';
        });
        print("Failed to fetch event: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        creatorFullname = 'Unknown';
      });
      print("Error fetching creator fullname: $e");
    }
  }

  // Function to check if the event is already liked by the user
  Future<void> _checkInitialLikeStatus() async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];
      final userId = ids['userId'];

      if (eventId == null || userId == null) {
        print("Event ID or User ID not found, skipping initial like check");
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/news/$eventId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final eventData = jsonDecode(response.body);
        final likedBy = (eventData['likedBy'] as List<dynamic>).map((item) => item['_id'] as String).toList();
        setState(() {
          fev = likedBy.contains(userId);
        });
        print("Initial like status: $fev");
      } else {
        print("Failed to fetch event details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking initial like status: $e");
    }
  }

  // Function to fetch full names of commenters
  Future<void> _fetchCommenterNames() async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];

      if (eventId == null) {
        print("No event ID found, skipping commenter fetch");
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/news/$eventId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final eventData = jsonDecode(response.body);
        final likedBy = (eventData['likedBy'] as List<dynamic>).map((item) => item['_id'] as String).toList();

        // Fetch full names for each commenter ID
        for (String commenterId in likedBy) {
          final userResponse = await http.get(
            Uri.parse('${AppConstants.baseUrl}/api/user/userid/$commenterId'),
            headers: {'Content-Type': 'application/json'},
          );

          if (userResponse.statusCode == 200) {
            final userData = jsonDecode(userResponse.body);
            setState(() {
              commenterNames[commenterId] = userData['user']['fullname'] ?? 'Unknown';
            });
            print("Commenter Fullname for ID $commenterId: ${commenterNames[commenterId]}");
          } else {
            setState(() {
              commenterNames[commenterId] = 'Unknown';
            });
            print("Failed to fetch user for ID $commenterId: ${userResponse.statusCode}");
          }
        }
      } else {
        print("Failed to fetch event details: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching commenter names: $e");
    }
  }

  // Function to handle the API call for liking/unliking the event
  Future<void> toggleLike() async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];
      final userId = ids['userId'];

      if (eventId == null || userId == null) {
        Fluttertoast.showToast(
          msg: 'Error: Event ID or User ID not found',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final String apiUrl = '${AppConstants.baseUrl}/api/news/$eventId/like';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fev = !fev;
        });
        print('Toast message: ${fev ? 'Event liked!' : 'Event unliked!'}');
        Fluttertoast.showToast(
          msg: fev ? 'Event liked!' : 'Event unliked!',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        // Refresh commenter names after liking/unliking
        _fetchCommenterNames();
      } else {
        print('Toast message: Failed to toggle like: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'You already liked this event',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Toast message: Error: $e');
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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
              title: Text(innerBoxIsScrolled ? widget.name ?? '' : ""),
              backgroundColor: primaryColor1,
              expandedHeight: 250.0,
              iconTheme: IconThemeData(color: white),
              automaticallyImplyLeading: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return Image.network(
                          widget.image ?? 'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network('https://via.placeholder.com/150', fit: BoxFit.cover);
                          },
                        );
                      },
                      onPageChanged: (value) {
                        setState(() => currentIndexPage = value);
                      },
                    ),
                    DotIndicator(
                      pageController: pageController,
                      pages: walkThroughList,
                      indicatorColor: white,
                      unselectedIndicatorColor: grey,
                    ).paddingBottom(8),
                  ],
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: toggleLike,
                  child: Icon(
                    fev ? Icons.favorite : Icons.favorite_border,
                    color: fev ? Colors.red : white,
                  ).paddingRight(12),
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: InkWell(
            splashColor: primaryColor1.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.hashTag ?? '', style: secondaryTextStyle()).paddingOnly(left: 12, top: 8, bottom: 8),
                Text(widget.name ?? 'Unnamed Event', style: boldTextStyle()).paddingOnly(left: 12, bottom: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.detail ?? 'This is come and back',
                        style: boldTextStyle(),
                      ).paddingOnly(left: 12, right: 12, bottom: 8),
                    ),
                  ],
                ).paddingOnly(left: 12, bottom: 8),
                // Display creator's fullname
                Text(
                  "Posted by: ${creatorFullname ?? 'Loading...'}",
                  style: secondaryTextStyle(size: 14),
                ).paddingOnly(left: 12, bottom: 8),
                16.height,
                // Display list of likers/commenters with their full names
                if (commenterNames.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Liked by:",
                        style: boldTextStyle(size: 16),
                      ).paddingOnly(left: 12, bottom: 8),
                      ...commenterNames.entries.map((entry) {
                        return Text(
                          entry.value, // Display full name
                          style: secondaryTextStyle(size: 14),
                        ).paddingOnly(left: 12, bottom: 4);
                      }).toList(),
                    ],
                  ),
                16.height,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      100.width,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor1, primaryColor2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor1.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.comment, color: white, size: 20),
                            8.width,
                            Text('Write Comment', style: primaryTextStyle(color: white)),
                          ],
                        ),
                      ).onTap(() {
                        EAReviewScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
                      }, splashColor: white.withOpacity(0.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}