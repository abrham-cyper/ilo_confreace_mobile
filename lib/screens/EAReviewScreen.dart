import 'package:event_prokit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/model/EAReviewModel.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

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
  Future<List<EAReviewModel>>? reviewData;

  @override
  void initState() {
    super.initState();
    reviewData = fetchReviewData();
  }

  Future<List<EAReviewModel>> fetchReviewData() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/news/67d23d74a2f7c45b706995d3'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['news'];

        List<EAReviewModel> reviews = [];

        // Loop through all comments and map them to the EAReviewModel
        for (var comment in jsonData['comments']) {
          DateTime createdAt = DateTime.parse(comment['createdAt']);
          String timeAgo = timeago.format(createdAt);

          reviews.add(EAReviewModel(
            name: comment['user']['_id'] ?? 'Unknown User', // Display user _id as name
            image: jsonData['image'] ?? 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg',
            fev: false,
            time: timeAgo, // Display time in "ago" format
            like: 12, // Hardcoded as per your request
            msg: comment['text'] ?? 'No comments yet', // Display comment text
          ));
        }
        return reviews;
      } else {
        throw Exception('Failed to load review data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [
        EAReviewModel(
          name: 'Error',
          image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg',
          fev: false,
          time: 'N/A',
          like: 12,
          msg: 'Failed to load data',
        )
      ];
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: primaryColor1,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.arrow_back, color: Colors.white),
            10.width,
            Icon(Icons.info_outline, color: Colors.white),
            20.width,
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        "Reviews",
        backWidget: Icon(Icons.close, color: white).onTap(() {
          finish(context);
        }),
        center: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<EAReviewModel>>(
            future: reviewData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<EAReviewModel> reviews = snapshot.data!;

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    EAReviewModel data = reviews[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          commonCachedNetworkImage(
                            data.image!,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ).cornerRadiusWithClipRRect(35),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.name!, style: boldTextStyle()), // User _id as name
                              4.height,
                              data.msg == null
                                  ? SizedBox()
                                  : Text(
                                      data.msg.validate(),
                                      style: secondaryTextStyle(),
                                    ).visible(data.msg!.isNotEmpty), // Comment text as message
                              4.height,
                              Text(data.time!, style: secondaryTextStyle()), // Time in "ago" format
                            ],
                          ).expand(),
                          Row(
                            children: [
                              Text(data.like!.toString(), style: secondaryTextStyle()).visible(data.like != null),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border, size: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(child: Text('No data available'));
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
                      suffixIcon: Icon(Icons.send, size: 30, color: primaryColor1).onTap(
                        () {
                          reviewController.clear();
                        },
                      ),
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
}
