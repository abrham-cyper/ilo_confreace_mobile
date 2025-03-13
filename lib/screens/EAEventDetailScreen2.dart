import 'package:event_prokit/utils/EAapp_widgets.dart';
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

class EAEventDetailScreen2 extends StatefulWidget {
  final String? name;
  final String? hashTag;
  final String? attending;
  final String? price;
  final String? image;
  final String? detail;

  EAEventDetailScreen2({this.name, this.hashTag, this.attending, this.price, this.image, this.detail});

  @override
  _EAEventDetailScreen2tate createState() => _EAEventDetailScreen2tate();
}

class _EAEventDetailScreen2tate extends State<EAEventDetailScreen2> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  bool fev = false; // Tracks if the event is liked or not

  // Function to handle the API call for liking the event
  Future<void> toggleLike() async {
    const String apiUrl = 'http://192.168.122.25:3000/api/news/67d23d74a2f7c45b706995d3/like';
    const String userId = '67cc7d96e67a183122f447c7'; // Hardcoded userId for this example

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fev = !fev; // Toggle the like state
        });
        print('Toast message: ${fev ? 'Event liked!' : 'Event unliked!'}');
        Fluttertoast.showToast(
          msg: fev ? 'Event liked!' : 'Event unliked!',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
      } else {
        print('Toast message: Failed to toggle like: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'You alerday liked',
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
                  onTap: toggleLike, // Trigger the like function on tap
                  child: Icon(
                    fev ? Icons.favorite : Icons.favorite_border, // Toggle between filled and border icon
                    color: fev ? Colors.red : white, // Change color when liked
                  ).paddingRight(12),
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: InkWell(
            splashColor: primaryColor1.withOpacity(0.2), // Cool splash effect
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
                16.height,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out elements
                    children: [
                      100.width, // Spacer
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor1, primaryColor2], // Cool gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor1.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4), // Shadow effect
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
                      }, splashColor: white.withOpacity(0.3)), // Cool splash effect on tap
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