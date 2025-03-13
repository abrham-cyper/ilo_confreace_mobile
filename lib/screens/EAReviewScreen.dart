import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/model/EAReviewModel.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

class EAReviewScreen extends StatefulWidget {
  const EAReviewScreen({Key? key}) : super(key: key);

  @override
  _EAReviewScreenState createState() => _EAReviewScreenState();
}

class _EAReviewScreenState extends State<EAReviewScreen> {
  TextEditingController reviewController = TextEditingController();
  Future<EAReviewModel>? reviewData;

  @override
  void initState() {
    super.initState();
    reviewData = fetchReviewData();
  }

  Future<EAReviewModel> fetchReviewData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.75.25:3000/api/news/67d23a1da2f7c45b706995a3'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['news'];

        // Convert createdAt to a DateTime object
        DateTime createdAt = DateTime.parse(jsonData['comments']?.isNotEmpty == true ? jsonData['comments'][0]['createdAt'] ?? '' : '');

        // Convert the DateTime to "ago" format
        String timeAgo = timeago.format(createdAt);

        return EAReviewModel(
          name: jsonData['id'] ?? 'Unknown ID', // Fallback for name
          image: jsonData['image'] ?? 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', // Use backend image or fallback
          fev: false,
          time: timeAgo, // Time in "ago" format
          like: 12, // Hardcoded as per request
          msg: jsonData['comments']?.isNotEmpty == true ? jsonData['comments'][0]['text'] ?? 'No message' : 'No comments yet',
        );
      } else {
        throw Exception('Failed to load review data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return EAReviewModel(
        name: 'Error',
        image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg',
        fev: false,
        time: 'N/A',
        like: 12,
        msg: 'Failed to load data',
      );
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
          FutureBuilder<EAReviewModel>(
            future: reviewData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                EAReviewModel data = snapshot.data!;

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
                          Text(data.name!, style: boldTextStyle()), // ID as name
                          4.height,
                          data.msg == null
                              ? SizedBox()
                              : Text(
                                  data.msg.validate(),
                                  style: secondaryTextStyle(),
                                ).visible(data.msg!.isNotEmpty), // Comment as message
                          4.height,
                          Text(data.time!, style: secondaryTextStyle()), // Time from backend, now in "ago" format
                        ],
                      ).expand(),
                      Row(
                        children: [
                          Text(data.like!.toString(), style: secondaryTextStyle()).visible(data.like != null), // Likes hardcoded as 12
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite_border, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
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

// Assuming EAReviewModel class is defined as follows (update if different):
class EAReviewModel {
  String? name;
  String? image;
  bool? fev;
  String? time;
  int? like;
  String? msg;

  EAReviewModel({this.name, this.image, this.fev, this.time, this.like, this.msg});
}
