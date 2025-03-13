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
import 'package:socket_io_client/socket_io_client.dart' as IO;

class EAMayBEYouKnowScreen extends StatefulWidget {
  @override
  EAMayBEYouKnowScreenState createState() => EAMayBEYouKnowScreenState();
}

class EAMayBEYouKnowScreenState extends State<EAMayBEYouKnowScreen> {
  List<EAForYouModel> list = [];
  bool isLoading = true;
  bool hasError = false; // Track if an error occurred
  late IO.Socket socket; // Socket.IO client instance

  @override
  void initState() {
    super.initState();
    initializeSocket(); // Initialize Socket.IO
    fetchData();
  }

  // Function to initialize Socket.IO connection
  void initializeSocket() {
    socket = IO.io('http://192.168.180.25:4000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });

    // Listen for new messages in real-time
    socket.on('newMessage', (data) {
      print('New message received: $data');
      fetchData(); // Refresh the list when a new message is received
    });

    // Listen for messages seen events in real-time
    socket.on('messagesSeen', (data) {
      print('Messages seen: $data');
      fetchData(); // Refresh the list when messages are seen
    });
  }

  // Function to join a conversation room
  void joinConversation(String conversationId) {
    socket.emit('joinConversation', conversationId);
    print('Joined conversation: $conversationId');
  }

  // Function to fetch data from the backend
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false; // Reset error state
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.180.25:4000/api/messages/list/john_doe'),
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

        // Join all conversation rooms for real-time updates
        for (var item in fetchedList) {
          if (item.conversationId != null) {
            joinConversation(item.conversationId!);
          }
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
          hasError = true;
        });
        toast('Failed to load data. Please try again.');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
      toast('An error occurred while fetching data. Please try again.');
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
  void dispose() {
    socket.disconnect(); // Disconnect Socket.IO when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load data', style: boldTextStyle()),
                      16.height,
                      ElevatedButton(
                        onPressed: fetchData, // Retry fetching data
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
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
                              joinConversation(conversationId); // Join the conversation room
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