import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EADataProvider.dart';
import 'package:event_prokit/utils/EAImages.dart';
import 'package:event_prokit/main.dart';
import 'package:url_launcher/url_launcher.dart';


import 'EAReviewScreen.dart';
import 'EATicketDetailScreen.dart';

class EAEventDetailScreen extends StatefulWidget {
  final String? name;
  final String? hashTag;
  final String? attending;
  final String? price;
  final String? image;
  final String? about;
  final String? location;
  final String? phone;
  final String? email;

  EAEventDetailScreen({
    this.name,
    this.hashTag,
    this.attending,
    this.price,
    this.image,
    this.about,
    this.location,
    this.phone,
    this.email,
  });

  @override
  _EAEventDetailScreenState createState() => _EAEventDetailScreenState();
}

class _EAEventDetailScreenState extends State<EAEventDetailScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  String des = "why this party is for you";
  String des1 = "Let's play silent game.but this time you have to dance under the star white hundreds... ";
  bool fev = false;

  // Function to open Google Maps
  Future<void> _openGoogleMaps() async {
    const double latitude = 9.0065;
    const double longitude = 38.7633;
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  // Function to share all event details via specific apps
  Future<void> _shareViaApp(String appScheme) async {
    final String eventName = widget.name ?? 'Event';
    final String eventImage = widget.image ?? 'https://via.placeholder.com/150';
    final String eventAbout = widget.about ?? 'No description available';
    final String eventLocation = widget.location ?? 'Bole, Addis Ababa, Ethiopia';
    final String eventPrice = widget.price ?? '0';
    final String eventPhone = widget.phone ?? '+1 991-681-0200';
    final String eventEmail = widget.email ?? 'help@Event.com';
    
    final String shareText = 'Check out this event!\n'
        'Name: $eventName\n'
        'About: $eventAbout\n'
        'Location: $eventLocation\n'
        'Price: ETB $eventPrice\n'
        'Image: $eventImage\n'
        'Contact: $eventPhone | $eventEmail\n'
        'More info: https://iloethiopia2025.gov.et/';
    
    final String encodedText = Uri.encodeFull(shareText);
    String shareUrl;

    switch (appScheme) {
      case 'telegram':
        shareUrl = 'tg://msg?text=$encodedText';
        break;
      case 'whatsapp':
        shareUrl = 'whatsapp://send?text=$encodedText';
        break;
      case 'email':
        shareUrl = 'mailto:?subject=Check%20out%20this%20event&body=$encodedText';
        break;
      default:
        shareUrl = encodedText; // Fallback to default share
    }

    if (await canLaunch(shareUrl)) {
      await launch(shareUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $appScheme')),
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
              title: Text(innerBoxIsScrolled ? widget.name ?? 'Event Details' : ""),
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
                            return Image.network(
                              'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                            );
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
                PopupMenuButton<String>(
                  icon: Icon(AntDesign.sharealt, color: white),
                  onSelected: (String value) {
                    _shareViaApp(value); // Updated to not require URL parameter
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'telegram',
                      child: Row(
                        children: [
                          Icon(Icons.telegram, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Telegram'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'whatsapp',
                      child: Row(
                        children: [
                          Icon(Icons.chat, color: Colors.green),
                          SizedBox(width: 8),
                          Text('WhatsApp'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'email',
                      child: Row(
                        children: [
                          Icon(Icons.email, color: Colors.grey),
                          SizedBox(width: 8),
                          Text('Email'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'other',
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Other'),
                        ],
                      ),
                    ),
                  ],
                ).paddingRight(12),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("", style: boldTextStyle()).paddingOnly(left: 12, bottom: 2),
              Text(
                widget.name ?? 'No Event Name',
                style: boldTextStyle(),
              ).paddingOnly(left: 12, bottom: 8),
              2.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About'.toUpperCase(), style: boldTextStyle(color: grey)),
                  8.height,
                  Text(
                    widget.about ?? 'No description available',
                    style: primaryTextStyle(),
                  ),
                  Text(
                    widget.attending ?? '0 attending',
                    style: primaryTextStyle(),
                  ),
                  Row(
                    children: [
                      Text("Detail", style: primaryTextStyle(color: primaryColor1)),
                      4.width,
                      Icon(Icons.arrow_forward_ios_outlined, size: 14, color: primaryColor1),
                    ],
                  ),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location'.toUpperCase(), style: boldTextStyle(color: grey)),
                  GestureDetector(
                    onTap: _openGoogleMaps,
                    child: Row(
                      children: [
                        Text(
                          "How to get there",
                          style: primaryTextStyle(color: primaryColor1),
                        ),
                        4.width,
                        Icon(Icons.arrow_forward_ios_outlined, size: 14, color: primaryColor1),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.location ?? 'Bole, Addis Ababa, Ethiopia',
                    style: secondaryTextStyle(),
                  ),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
              commonCachedNetworkImage(
                event_ic_map,
                fit: BoxFit.cover,
                height: 200,
                width: context.width(),
              ),
              Text(
                'Contact'.toUpperCase(),
                style: boldTextStyle(color: grey),
              ).paddingOnly(left: 12, bottom: 8, top: 8),
              createRichText(
                list: [
                  TextSpan(text: "Send us an email at ", style: primaryTextStyle()),
                  TextSpan(
                    text: widget.email ?? " help@Event.com",
                    style: primaryTextStyle(color: primaryColor1),
                  ),
                  TextSpan(text: " or call us at ", style: primaryTextStyle()),
                  TextSpan(
                    text: widget.phone ?? " +1 991-681-0200",
                    style: primaryTextStyle(color: primaryColor1),
                  ),
                ],
              ).paddingOnly(left: 12, bottom: 8, top: 8, right: 12),
            ],
          ),
        ),
      ),
   bottomNavigationBar: Container(
  alignment: Alignment.center,
  margin: EdgeInsets.all(20),
  width: context.width(),
  height: 50,
  decoration: boxDecorationWithShadow(
    borderRadius: radius(24),
    gradient: LinearGradient(colors: [primaryColor1, black]),
  ),
  child: InkWell(
    onTap: () async {
      const url = 'https://iloethiopia2025.gov.et/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: Center(
      child: widget.price == "Free"
          ? Text('Join it free'.toUpperCase(), style: boldTextStyle(color: white))
          : Text(
              'Register'.toUpperCase(),
              style: boldTextStyle(color: white),
            ),
    ),
  ),
),

    );

  }
}