import 'dart:convert';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/main.dart';
import 'EAEventDetailScreen.dart';
import '../utils/constants.dart';

class EAForYouTabScreen extends StatefulWidget {
  @override
  EAForYouTabScreenState createState() => EAForYouTabScreenState();
}

class EAForYouTabScreenState extends State<EAForYouTabScreen> {
  List<EAForYouModel> forYouList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/events'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          forYouList = data.map((event) => EAForYouModel.fromJson(event)).toList();
        });
      } else {
        print('Failed to load events: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: forYouList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: boxDecorationRoundedWithShadow(
                      8,
                      backgroundColor: appStore.isDarkModeOn ? cardDarkColor : white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesome.street_view, color: primaryColor1),
                        Text(
                          "Addis Ababa 19-23 May 2025",
                          style: primaryTextStyle(color: primaryColor1, size: 18),
                          textAlign: TextAlign.center,
                        ).expand(),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: forYouList.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              commonCachedNetworkImage(
                                forYouList[i].image!,
                                height: 230,
                                width: context.width(),
                                fit: BoxFit.cover,
                              ),
                            
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: primaryColor1,
                                  borderRadius: radius(0),
                                ),
                                child: forYouList[i].time == null
                                    ? SizedBox()
                                    : Row(
                                        children: [
                                          Icon(MaterialCommunityIcons.timer_sand, color: white),
                                          10.width,
                                          Text(forYouList[i].time.toString(), style: primaryTextStyle(color: white)),
                                        ],
                                      ),
                              ).visible(forYouList[i].time != null),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    forYouList[i].name ?? forYouList[i].name ?? 'No Title', // Fallback if note and name are null
                                    style: boldTextStyle(),
                                  ),
                                  Text(
                                    'ETB ${forYouList[i].price ?? 0}', // Fallback for null price
                                    style: boldTextStyle(color: primaryColor1),
                                  ),
                                ],
                              ),
                              4.height,
                              Text(
                                forYouList[i].note ?? '', // Fallback for null hashtag
                                style: secondaryTextStyle(),
                              ),
                              4.height,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  8.width,
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
                                      Text(
                                        forYouList[i].add ?? 'No Address', // Fallback for null address
                                        style: secondaryTextStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              6.height,
                            ],
                          ).paddingAll(16)
                        ],
                      ).onTap(() {
                        EAEventDetailScreen(
                          name: forYouList[i].name ?? 'No Name', // Fallback for null name
                          hashTag: forYouList[i].hashtag ?? '', // Fallback for null hashtag
                          attending: forYouList[i].attending?.toString() ?? '0', // Fallback for null attending
                          price: forYouList[i].price?.toString() ?? '0', // Convert int? to String with fallback
                          image: forYouList[i].image ?? '',
                          about: forYouList[i].about ?? 'No description available', // Fallback for null about
                          location: forYouList[i].location ?? '',
                          email: forYouList[i].email ?? '',
                          phone: forYouList[i].phone?? '',
                         
                        ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class EAForYouModel {
  String? hashtag;
  String? name;
  double? rating;
  String? add;
  int? attending;
  String? time;
  String? image;
  int? price;
  double? distance;
  bool? fev;
  String? about;
  String? location;
  String? email;
  String? phone;
  String? note;

  EAForYouModel({
    this.hashtag,
    this.name,
    this.rating,
    this.add,
    this.attending,
    this.time,
    this.image,
    this.distance,
    this.price,
    this.fev = false,
    this.about,
    this.location,
    this.email,
    this.phone,
    this.note,
  });

  factory EAForYouModel.fromJson(Map<String, dynamic> json) {
    return EAForYouModel(
      hashtag: json['hashtag'] as String?,
      name: json['name'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      add: json['add'] as String?,
      attending: json['attending'] as int?,
      time: json['time'] as String?,
      image: json['image'] as String?,
      price: json['price'] as int?,
      distance: (json['distance'] as num?)?.toDouble(),
      fev: json['fev'] as bool? ?? false,
      about: json['about'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      note: json['note'] as String?,
    );
  }
}