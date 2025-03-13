import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import 'package:confetti/confetti.dart';
import 'package:event_prokit/main.dart'; // Import main.dart for appStore

class Vote extends StatefulWidget {
  @override
  VoteState createState() => VoteState();
}

class VoteState extends State<Vote> {
  List<Map<String, dynamic>> countries = [
    {"name": "Ethiopia", "nativeName": "ኢትዮጵያ", "votes": 0, "flag": "🇪🇹", "color": Colors.green},
    {"name": "Dominican Republic", "nativeName": "República Dominicana", "votes": 0, "flag": "🇩🇴", "color": Colors.red},
    {"name": "Singapore", "nativeName": "新加坡", "votes": 0, "flag": "🇸🇬", "color": Colors.red},
    {"name": "Zambia", "nativeName": "Zambia", "votes": 0, "flag": "🇿🇲", "color": Colors.orange},
  ];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void castVote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Your Vote", style: boldTextStyle()),
        content: Text("Vote for ${countries[index]['name']} (${countries[index]['nativeName']})?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: secondaryTextStyle()),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                countries[index]["votes"] += 1;
                _confettiController.play();
                toast("Vote cast for ${countries[index]['name']}!");
              });
              Navigator.pop(context);
            },
            child: Text("Confirm", style: boldTextStyle(color: primaryColor1)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort countries by votes for leaderboard
    List<Map<String, dynamic>> sortedCountries = List.from(countries)..sort((a, b) => b["votes"].compareTo(a["votes"]));
    int totalVotes = countries.map((c) => c["votes"]).reduce((a, b) => a + b) + 1; // Avoid division by zero

    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? Colors.grey[900] : Colors.grey[100], // Use appStore for theme
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leaderboard Section
                Container(
                  padding: EdgeInsets.all(16),
                  color: appStore.isDarkModeOn ? cardDarkColor : white, // Dynamic color based on theme
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Leaderboard", style: boldTextStyle(size: 20, color: primaryColor1)),
                      8.height,
                      Row(
                        children: [
                          Text(sortedCountries[0]["flag"], style: TextStyle(fontSize: 40)),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${sortedCountries[0]['name']} Leads!",
                                  style: boldTextStyle(size: 18, color: appStore.isDarkModeOn ? white : black)),
                              Text("${sortedCountries[0]['votes']} votes",
                                  style: secondaryTextStyle(color: appStore.isDarkModeOn ? grey : black)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: grey),
                // Voting Section
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Cast Your Vote!", style: boldTextStyle(size: 20, color: primaryColor1)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => castVote(index),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              countries[index]["color"].withOpacity(0.2),
                              appStore.isDarkModeOn ? Colors.grey[800]! : white
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: grey.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(countries[index]["flag"], style: TextStyle(fontSize: 30)),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(countries[index]["name"],
                                        style: boldTextStyle(size: 18, color: appStore.isDarkModeOn ? white : black)),
                                    Text(countries[index]["nativeName"],
                                        style: secondaryTextStyle(size: 14, color: appStore.isDarkModeOn ? grey : grey)),
                                    4.height,
                                    SizedBox(
                                      width: 150,
                                      child: LinearProgressIndicator(
                                        value: countries[index]["votes"] / totalVotes,
                                        backgroundColor: grey.withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(countries[index]["color"]),
                                      ),
                                    ),
                                    4.height,
                                    Text("${countries[index]["votes"]} votes",
                                        style: secondaryTextStyle(color: appStore.isDarkModeOn ? grey : black)),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () => castVote(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text("Vote", style: boldTextStyle(color: white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [primaryColor1, Colors.yellow, Colors.blue, Colors.red],
            ),
          ),
        ],
      ),
    );
  }
}