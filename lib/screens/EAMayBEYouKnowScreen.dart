import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/model/EAForYouModel.dart';
import 'package:event_prokit/screens/EAChattingScreen.dart';
import 'package:event_prokit/utils/EAColors.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'package:event_prokit/main.dart';
import 'dart:convert';

class EAMayBEYouKnowScreen extends StatefulWidget {
  @override
  EAMayBEYouKnowScreenState createState() => EAMayBEYouKnowScreenState();
}

class EAMayBEYouKnowScreenState extends State<EAMayBEYouKnowScreen> {
  List<EAForYouModel> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to fetch data from the backend
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.14:4000/api/messages/list/john_doe'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);

        // Explicitly map the JSON data to List<EAForYouModel>
        final List<EAForYouModel> fetchedList = jsonData.map((item) {
          return EAForYouModel(
            name: item['receiverUsername'] as String?,
            add: item['conversationId'] as String?, // Use conversationId as add
            image: 'https://randomuser.me/api/portraits/men/1.jpg', // Placeholder image
            fev: true, // Default value for fev
            conversationId: item['conversationId'] as String?, // Store conversationId
          );
        }).toList();

        setState(() {
          list = fetchedList;
          isLoading = false;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to save conversationId to shared_preferences
  Future<void> saveConversationId(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedConversationId', conversationId);
      print('Conversation ID saved..........................: $conversationId');

      // Retrieve and print the saved conversationId to verify
      final savedId = prefs.getString('selectedConversationId');
      print('Retrieved saved Conversation ID: $savedId');
    } catch (e) {
      print('Error saving conversation ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    EAForYouModel data = list[index];
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          commonCachedNetworkImage(
                            data.image,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ).cornerRadiusWithClipRRect(35),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.name ?? 'Unknown', style: boldTextStyle()),
                              4.height,
                              Text(data.add ?? 'N/A', style: secondaryTextStyle()),
                            ],
                          ).expand(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                list[index].fev = !(list[index].fev ?? false);
                              });
                            },
                            icon: Icon(
                              Icons.group,
                              color: list[index].fev ?? false
                                  ? primaryColor1
                                  : appStore.isDarkModeOn
                                      ? white
                                      : black,
                            ),
                          ),
                        ],
                      ),
                    ).onTap(
                      () {
                        String? username = list[index].name;
                        String? conversationId = list[index].conversationId;
                        if (conversationId != null) {
                          saveConversationId(conversationId); // Save conversationId to shared_preferences
                        }
                        EAChattingScreen(name: username).launch(context);
                      },
                    );
                  },
                ),
    );
  }
}

// Ensure EAForYouModel handles null safety correctly
class EAForYouModel {
  String? name;
  String? add;
  String? image;
  bool? fev;
  String? conversationId;

  EAForYouModel({
    this.name,
    this.add,
    this.image,
    this.fev,
    this.conversationId,
  });
}