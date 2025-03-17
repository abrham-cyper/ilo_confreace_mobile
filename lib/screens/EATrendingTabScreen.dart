import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import 'package:event_prokit/screens/EAEventDetailScreen2.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Added for SharedPreferences

// Updated Event model to match the new schema
class Event {
  final String id;
  final String name;
  final String address; // Changed from 'add'
  final String attending;
  final String hashtag;
  final double rating;
  final String price;
  final double distance;
  final String image;
  final List<String> likedBy; // Changed from 'fev' to 'likedBy' as a list
  final List<Comment> comments; // Added comments
  final String note; // Added note
  final String detail; // Added detail

  Event({
    required this.id,
    required this.name,
    required this.address,
    required this.attending,
    required this.hashtag,
    required this.rating,
    required this.price,
    required this.distance,
    required this.image,
    required this.likedBy,
    required this.comments,
    required this.note,
    required this.detail,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      address: json['address'], // Updated field name
      attending: json['attending'],
      hashtag: json['hashtag'],
      rating: json['rating'].toDouble(),
      price: json['price'],
      distance: json['distance'].toDouble(),
      image: json['image'],
      likedBy: (json['likedBy'] as List<dynamic>).map((item) => item['_id'] as String).toList(), // Extract user IDs
      comments: (json['comments'] as List<dynamic>).map((item) => Comment.fromJson(item)).toList(), // Parse comments
      note: json['note'],
      detail: json['detail'],
    );
  }
}

// Model for comments
class Comment {
  final String userId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user']['_id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class EATrendingTabScreen extends StatefulWidget {
  @override
  EATrendingTabScreenState createState() => EATrendingTabScreenState();
}

class EATrendingTabScreenState extends State<EATrendingTabScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/news'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((item) => Event.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      toast('Failed to load events'); // Optional: Show error to user
    }
  }

  // Function to save event ID to SharedPreferences
  Future<void> _saveEventId(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('event_id', eventId);
    print("Saved event_id to SharedPreferences: $eventId");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: events.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if no data
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 0),
              itemCount: events.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        commonCachedNetworkImage(events[i].image, height: 230, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(8),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: primaryColor1,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: events[i].hashtag.isEmpty
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Icon(MaterialCommunityIcons.timer_sand, color: white),
                                    10.width,
                                    Text(events[i].hashtag, style: primaryTextStyle(color: white)),
                                  ],
                                ),
                        ).visible(events[i].hashtag.isNotEmpty),
                      ],
                    ).paddingAll(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(events[i].name, style: boldTextStyle()),
                        4.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${events[i].note} ', style: secondaryTextStyle()),
                          ],
                        ),
                        6.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Entypo.location, size: 16),
                                8.width,
                                Text(events[i].address, style: secondaryTextStyle()),
                              ],
                            ),
                            Text('${events[i].likedBy.length} Like', style: secondaryTextStyle(color: primaryColor1)),
                          ],
                        ),
                        6.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon(Icons.local_activity_outlined, size: 16),
                                // 8.width,
                                // Text(events[i].attending, style: secondaryTextStyle()),
                              ],
                            ),
                            Text('${events[i].comments.length} comments', style: secondaryTextStyle()),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ],
                ).onTap(() async {
                  // Save the event ID to SharedPreferences before navigating
                  await _saveEventId(events[i].id);

                  // Navigate to event detail screen
                  EAEventDetailScreen2(
                    name: events[i].name,
                    hashTag: events[i].hashtag,
                    attending: events[i].attending,
                    price: events[i].price,
                    image: events[i].image,
                    detail: events[i].detail,
                  ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                });
              },
            ),
    );
  }
}