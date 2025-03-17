import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/model/EAReviewModel.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EAReviewScreen(),
    );
  }
}

class EAReviewScreen extends StatefulWidget {
  const EAReviewScreen({Key? key}) : super(key: key);

  @override
  _EAReviewScreenState createState() => _EAReviewScreenState();
}

class _EAReviewScreenState extends State<EAReviewScreen> {
  TextEditingController reviewController = TextEditingController();
  Future<List<dynamic>>? reviewData;
  Map<String, String> userCache = {}; // Cache user full names

  @override
  void initState() {
    super.initState();
    reviewData = fetchReviewData();
  }

  // Function to fetch eventId and userId from SharedPreferences
  Future<Map<String, String?>> _getIdsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getString('event_id');
    final userId = prefs.getString('user_id');
    print("Retrieved event_id: $eventId, user_id: $userId");
    return {'eventId': eventId, 'userId': userId};
  }

  // Function to fetch user's full name from API and cache it
  Future<String> fetchUserFullName(String userId) async {
    if (userCache.containsKey(userId)) {
      return userCache[userId]!;
    }

    try {
      final response = await http.get(Uri.parse('http://49.13.202.68:5001/api/user/userid/$userId'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        String fullName = jsonData['user']['fullname'] ?? 'Unknown User';
        userCache[userId] = fullName; // Cache the user's full name
        return fullName;
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return 'Unknown User';
    }
  }

  Future<List<dynamic>> fetchReviewData() async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];

      if (eventId == null) {
        print("No event ID found in SharedPreferences");
        return [Text("No event selected", style: boldTextStyle())];
      }

      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/news/$eventId'));
      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Parsed JSON Data: $jsonData");

        final comments = jsonData['comments'] as List<dynamic>? ?? [];
        print("Comments Array: $comments");

        if (comments.isEmpty) {
          return [
            Text(
              "There is no comment",
              style: boldTextStyle(),
              textAlign: TextAlign.center,
            )
          ];
        }

        List<EAReviewModel> reviews = [];

        // Preload full names for all users before building the review list
        for (var comment in comments) {
          DateTime createdAt = DateTime.parse(comment['createdAt'] ?? DateTime.now().toIso8601String());
          String timeAgo = timeago.format(createdAt);

          String userId = comment['user']['_id'] ?? '';
          String fullName = await fetchUserFullName(userId); // Retrieve the full name from cache or API

          reviews.add(EAReviewModel(
            name: fullName,
            image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_2J6g7oY_G0-F8v_uPkF_ZIYabsxindVGg-wyoX7sFjgFgHUvc-bYXtWtnHcOctJoWv0&usqp=CAU',
            fev: false,
            time: timeAgo,
            like: 12,
            msg: comment['text'] ?? 'No comment text',
          ));
        }
        print("Reviews Generated: $reviews");
        return reviews;
      } else {
        throw Exception('Failed to load review data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [
        Text(
          "There was an error: $e",
          style: boldTextStyle(),
          textAlign: TextAlign.center,
        )
      ];
    }
  }

  // Function to post a comment
  Future<void> _postComment(String text) async {
    try {
      final ids = await _getIdsFromPrefs();
      final eventId = ids['eventId'];
      final userId = ids['userId'];

      if (eventId == null || userId == null) {
        toast("Error: Event ID or User ID not found");
        return;
      }

      if (text.trim().isEmpty) {
        toast("Comment text is required");
        return;
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/api/news/$eventId/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'text': text}),
      );
      print("Post Comment Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201) {
        setState(() {
          reviewData = fetchReviewData();
        });
        reviewController.clear();
        toast("Comment added successfully");
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting comment: $e');
      toast("Failed to add comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        "Reviews 2",
        backWidget: Icon(Icons.close, color: white).onTap(() {
          finish(context);
        }),
        center: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: reviewData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: boldTextStyle()));
              } else if (snapshot.hasData) {
                List<dynamic> data = snapshot.data!;

                if (data.length == 1 && data[0] is Text) {
                  return Center(child: data[0]);
                }

                List<EAReviewModel> reviews = data.cast<EAReviewModel>();
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    EAReviewModel review = reviews[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonCachedNetworkImage(
                            review.image!,
                            fit: BoxFit.cover,
                            height: 70, // Increased from 50 to 70
                            width: 70,  // Increased from 50 to 70
                          ).cornerRadiusWithClipRRect(35), // Adjusted radius to match new size (half of width/height)
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.name!, style: boldTextStyle()),
                                4.height,
                                Text(
                                  review.msg ?? 'No comment text',
                                  style: secondaryTextStyle(),
                                ).visible(review.msg!.isNotEmpty),
                                4.height,
                                Text(review.time!, style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(child: Text('No data available', style: boldTextStyle()));
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationRoundedWithShadow(0, backgroundColor: context.cardColor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: reviewController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a review",
                      suffixIcon: Icon(Icons.send, size: 30, color: primaryColor1).onTap(() {
                        if (reviewController.text.isNotEmpty) {
                          _postComment(reviewController.text);
                        } else {
                          toast("Please enter a comment");
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EAReviewModel {
  String? name;
  String? image;
  bool? fev;
  String? time;
  int? like;
  String? msg;

  EAReviewModel({this.name, this.image, this.fev, this.time, this.like, this.msg});

  @override
  String toString() => 'EAReviewModel(name: $name, msg: $msg, time: $time)';
}
