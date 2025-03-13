import 'package:event_prokit/model/EAActivityModel.dart';
import 'package:event_prokit/model/EAEventListModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/model/EAForYouModel.dart';
import 'package:event_prokit/model/EAInboxModel.dart';
import 'package:event_prokit/model/EAReviewModel.dart';
import 'package:event_prokit/model/EATicketModel.dart';
import 'package:event_prokit/model/EAWalkThroughModel.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:flutter/material.dart';
import 'EAImages.dart';

List<EAWalkThrough> walkThroughList = [
  EAWalkThrough(image: event_ic_walk_through2, title: "ILO Regional Conference", subtitle: "ILO Regional Conference A Key Platform for Promoting Decent Work, Enhancing Social Dialogue, and Addressing Key Challenges in the Region"),
  EAWalkThrough(image: event_ic_walk_through3, title: "For Labour-based", subtitle: " 'Employment Intensive Investment Program: A Comprehensive Approach to Job Creation and Economic Growth"),
  EAWalkThrough(image: event_ic_walk_through1, title: "15-19 May 2025", subtitle: "Adwa Victory Memorial Museum Addis Ababa, Ethiopia"),
];

List<EACityModel> cityList = [
  EACityModel(name: "London", subtitle: "UK", image: event_ic_london),
  EACityModel(name: "New York", subtitle: "USA", image: event_ic_newYork),
  EACityModel(name: "Paris", subtitle: "France", image: event_ic_paris),
  EACityModel(name: "Tokyo", subtitle: "Japan", image: event_ic_tokyo),
  EACityModel(name: "London", subtitle: "UK", image: event_ic_london),
  EACityModel(name: "New york", subtitle: "USA", image: event_ic_newYork),
];

List<EACityModel> hashtagList = [
  EACityModel(name: "music", subtitle: "2k+ events", image: event_ic_music, selectHash: true),
  EACityModel(name: "festival", subtitle: "800+ events", image: event_ic_walk_through3, selectHash: true),
  EACityModel(name: "food", subtitle: "1.5k+ events", image: event_ic_food, selectHash: false),
  EACityModel(name: "cinema", subtitle: "3.4k+ events", image: event_ic_cinema, selectHash: false),
  EACityModel(name: "music", subtitle: "800+ events", image: event_ic_music, selectHash: false),
  EACityModel(name: "festival", subtitle: "1.5k+ events", image: event_ic_walk_through3, selectHash: false),
];

List<EACityModel> filterDateList = [
  EACityModel(name: "All Dates"),
  EACityModel(name: "Today"),
  EACityModel(name: "Tomorrow"),
  EACityModel(name: "This week"),
];

List<EACityModel> filterHashtagList = [
  EACityModel(name: "All Hashtags", isSelected: false),
  EACityModel(name: "music", isSelected: false),
  EACityModel(name: "festival", isSelected: false),
  EACityModel(name: "food", isSelected: false),
  EACityModel(name: "cinema", isSelected: false),
  EACityModel(name: "music", isSelected: false),
  EACityModel(name: "festival", isSelected: false),
];
List<EAForYouModel> forYouList = [
  EAForYouModel(
      name: "National Delegates", add: "Addis Ababa, Ethiopia", attending: "19/5k attending", hashtag: "15-19 May 2025", rating: 4.3,  time: "27 days 06 Hrs 27 Mins 44 Secs,", price: "15000", distance: 8, image: event_ic_london, fev: true),
  EAForYouModel(
      name: "International Delegates",
      add: "Addis Ababa, Ethiopia",
      attending: "19/5k attending",
      hashtag: "15-19 May 2025",
      rating: 4.3,
      time: "27 days 06 Hrs 27 Mins 44 Secs,",
      price: "20000",
      distance: 8,
      image: event_ic_tokyo,
      fev: false),
  EAForYouModel(
      name: "Exhibitors", add: "Addis Ababa, Ethiopia", attending: "19/5k attending", hashtag: "15-19 May 2025", rating: 4.3, time: "27 days 06 Hrs 27 Mins 44 Secs,", price: "20", distance: 8, image: event_ic_paris, fev: false),
   
];

List<EAForYouModel> Events = [
  EAForYouModel(
      name: "National234234 Delegates", add: "Addis Ababa, Ethiopia", attending: "19/5k attending", hashtag: "15-19 May 2025", rating: 4.3,   price: "15000", distance: 8, image: event_ic_london, fev: true),
 

];


List<EAForYouModel> Mybages= [
  EAForYouModel(
      name: "National Delegates", add: "Addis Ababa, Ethiopia", attending: "19/5k attending", hashtag: "15-19 May 2025", rating: 4.3,   price: "15000", distance: 8, image: event_ic_london, fev: true),
 

];




List<EAForYouModel> getMayKnowData() {
  List<EAForYouModel> list = [];
  list.add(EAForYouModel(name: "Abrham Assefa", add: "156 followers", image: 'https://i.pinimg.com/736x/9a/7b/40/9a7b4099d1a9d5ff523aa0ff4ea3536c.jpg', fev: false));
  return list;
}

List<EAMessageModel> getChatMsgData() {
  List<EAMessageModel> list = [];

  EAMessageModel c1 = EAMessageModel();
  c1.senderId = EASender_id;
  c1.receiverId = EAReceiver_id;
  c1.msg = 'Helloo';
  c1.time = '1:43 AM';
  list.add(c1);

 

  

  return list;
}

List<EAEventList> eventList = [
  EAEventList(name: "Ethiopian Roads Authority", date: "MAR 30,2016", image: "https://i.pinimg.com/736x/b9/f7/ff/b9f7ff18166e9ace78d0d1701873b3b1.jpg"),
  EAEventList(name: "ministry of urban and infrastructure", date: "MAR 24,2018", image: "https://i.pinimg.com/736x/ff/60/6c/ff606c2bc529912d047f382537452984.jpg"),
  EAEventList(name: "Global employment trends: Challenges and opportunities", date: "MAR 20,2018", image: "https://i.pinimg.com/736x/59/7a/7a/597a7a99f969340902321868c6fbe49e.jpg"),
  
];

List<EAReviewModel> reviewList() {
  List<EAReviewModel> list = [];
  list.add(
      EAReviewModel(name: "abrshi", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', fev: false, time: "3 Hours ago", rating: 4.3, like: 12, msg: "Good"));
  list.add(EAReviewModel(
      name: "kail", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.1.jpg', fev: false, time: "4 Hours ago", rating: 1, like: 1, msg: "Awesome images..."));
  list.add(EAReviewModel(
      name: "burat", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.2.jpg', fev: false, time: "6 Hours ago", rating: 3.4, like: 6, msg: "great event"));
  
  return list;
}

List<EATicketModel> ticketList = [
  EATicketModel(name: "Normal Ticket", time: "4:30 until 6:30", payment: "Sold Out", count: 0),
  EATicketModel(name: "VIP Ticket", time: "6:30 until 7:30", payment: "*\$80=\$0", count: 0),
  EATicketModel(name: "Normal Ticket", time: "4:30 until 6:30", payment: "*\$80=\$0", count: 0),
  EATicketModel(name: "VIP Ticket", time: "6:30 until 7:30", payment: "*\$80=\$160", count: 2),
];

List<EACityModel> cardList = [
  EACityModel(image: event_ic_visa),
  EACityModel(image: event_ic_master),
  EACityModel(image: event_ic_amex),
];

List<EAInboxModel> inboxList = [
  EAInboxModel(msg: "Ethiopian Roads Authority", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', name: "jose Lowe"),
  EAInboxModel(msg: "Bike New York For Bike Month", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.1.jpg', name: "Smit Jhon"),
  EAInboxModel(msg: "Washington Square Outdoor Art Exhibit", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.2.jpg', name: "Louisa Lyons"),
  EAInboxModel(msg: "Why Las vegas hotal Room For you", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.3.jpg', name: "Hulda James"),
  EAInboxModel(msg: "Bike New York For Bike Month", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.4.jpg', name: "Bessie Mendoza"),
  EAInboxModel(msg: "Washington Square Outdoor Art Exhibit", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', name: "Matilda MCGuire"),
  EAInboxModel(msg: "Why Las vegas hotal Room For you", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.1.jpg', name: "Harriett Coleman"),
  EAInboxModel(msg: "Fashion finest AW17 During London Fashion Week", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', name: "jose Lowe"),
  EAInboxModel(msg: "Bike New York For Bike Month", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.1.jpg', name: "Smit Jhon"),
  EAInboxModel(msg: "Washington Square Outdoor Art Exhibit", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.2.jpg', name: "Louisa Lyons"),
  EAInboxModel(msg: "Why Las vegas hotal Room For you", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.3.jpg', name: "Hulda James"),
  EAInboxModel(msg: "Bike New York For Bike Month", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.4.jpg', name: "Bessie Mendoza"),
  EAInboxModel(msg: "Washington Square Outdoor Art Exhibit", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg', name: "Matilda MCGuire"),
  EAInboxModel(msg: "Why Las vegas hotal Room For you", image: 'https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.1.jpg', name: "Harriett Coleman"),
];

List<EAActivityModel> activityList = [
  EAActivityModel(name: "National Delegates", image: event_ic_music, icon: Icons.login_outlined, subtitle: "joined the list", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "Emc Black ticket", image: event_ic_walk_through1, icon: Icons.shopping_cart_outlined, subtitle: "Brought ticket", time: "mar 26,2018", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "win 2 tickets to WWE @MSC", image: event_ic_festival, icon: Icons.shopping_cart_outlined, subtitle: "Brought ticket", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "Bottled Art wine painting night", image: event_ic_cinema, icon: Icons.login_outlined, subtitle: "joined the list", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "Emc Black ticket", image: event_ic_tokyo, icon: Icons.login_outlined, subtitle: "joined the list", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "win 2 tickets to WWE @MSC", image: event_ic_paris, icon: Icons.login_outlined, subtitle: "joined the list", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
  // EAActivityModel(name: "Bottled Art wine painting night", image: event_ic_music, icon: Icons.login_outlined, subtitle: "joined the list", time: "10 min ago", subtime: "sun mar,25 - 4.30 pm est"),
];

List<EAActivityModel> notificationList = [
  EAActivityModel(name: "eyaseu", image: "https://i.pinimg.com/736x/52/46/49/524649971a55b2f3a0dae1d537c61098.jpg", time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: "joined the list"),
  EAActivityModel(name: "yarade ", image: "https://i.pinimg.com/736x/8d/a7/41/8da7418c70faa5abfacc5bd20ba78e23.jpg", time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: "joined the list "),
  // EAActivityModel(name: "innie Lyons", image: event_ic_festival, time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: "joined the list"),
  // EAActivityModel(name: "Sandra minalo", image: event_ic_cinema, time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: " Brought ticket"),
  // EAActivityModel(name: "Linnie Lyons", image: event_ic_tokyo, time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: "joined the list"),
  // EAActivityModel(name: "Sandra minalo", image: event_ic_paris, time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: " Brought ticket"),
  // EAActivityModel(name: "Linnie Lyons", image: event_ic_music, time: "send you message", subtime: "sun mar,25 - 4.30 pm est", subtitle: "oined the list"),
];

List<EAActivityModel> imageList = [
  EAActivityModel(image: event_ic_newYork),
  EAActivityModel(image: event_ic_paris),
  EAActivityModel(image: event_ic_tokyo),
];

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'images/flag/ic_hi.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'images/flag/ic_fr.png'),
  ];
}
