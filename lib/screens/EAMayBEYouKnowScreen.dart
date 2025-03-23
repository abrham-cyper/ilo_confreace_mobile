import 'package:event_prokit/utils/constants.dart';
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
  bool isLoading = false; // Changed to false initially
  bool hasError = false;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    initializeSocket();
    loadData(); // Changed from fetchData() to loadData()
  }

  void initializeSocket() {
    socket = IO.io('http://49.13.202.68:3000', <String, dynamic>{
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

    socket.on('newMessage', (data) {
      print('New message received: $data');
      fetchData(); // Refresh data when new message arrives
    });

    socket.on('messagesSeen', (data) {
      print('Messages seen: $data');
      fetchData(); // Refresh data when messages are seen
    });
  }

  void joinConversation(String conversationId) {
    socket.emit('joinConversation', conversationId);
    print('Joined conversation: $conversationId');
  }

  Future<String?> fetchFullname(String userId) async {
    final url = 'http://49.13.202.68:5001/api/user/userid/$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['exists'] == true && data['user'] != null) {
          return data['user']['fullname'] ?? 'Unknown';
        }
      }
      return 'Unknown';
    } catch (e) {
      print('Error fetching fullname for $userId: $e');
      return 'Unknown';
    }
  }

  Future<String?> fetchLastMessage(String conversationId) async {
    final url = 'http://49.13.202.68:3000/api/messages/conversation/$conversationId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> messages = jsonDecode(response.body);
        if (messages.isNotEmpty) {
          final lastMessage = messages.last;
          return lastMessage['message'] ?? 'No message content';
        }
        return 'No messages yet';
      }
      return 'Failed to load messages';
    } catch (e) {
      print('Error fetching last message for $conversationId: $e');
      return 'Error loading message';
    }
  }

  // Load data from cache or fetch from API
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedUserList');

    if (cachedData != null) {
      // Load from cache
      final List<dynamic> jsonData = jsonDecode(cachedData);
      setState(() {
        list = jsonData.map((json) => EAForYouModel(
          name: json['name'],
          lastMessage: json['lastMessage'],
          image: json['image'],
          fev: json['fev'],
          conversationId: json['conversationId'],
        )).toList();
        isLoading = false;
        hasError = false;
      });
      // Fetch fresh data in background
      fetchData();
    } else {
      // No cache, fetch directly
      fetchData();
    }
  }

  // Fetch data from API and save to cache
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userid');

      if (userId == null) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
        toast('User ID not found. Please log in again.');
        return;
      }

      final response = await http.get(
        Uri.parse('http://49.13.202.68:3000/api/messages/list/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print('Messages list response: $jsonData');

        List<Future<EAForYouModel>> futures = jsonData.map((item) async {
          String? receiverUserId = item['receiverUsername'] as String?;
          String? conversationId = item['conversationId'] as String?;

          final results = await Future.wait([
            fetchFullname(receiverUserId ?? ''),
            fetchLastMessage(conversationId ?? ''),
          ]);

          String fullname = results[0] ?? 'Unknown';
          String lastMessage = results[1] ?? 'No messages yet';

          return EAForYouModel(
            name: fullname,
            lastMessage: lastMessage,
            image: 'https://randomuser.me/api/portraits/men/1.jpg',
            fev: true,
            conversationId: conversationId,
          );
        }).toList();

        List<EAForYouModel> fetchedList = await Future.wait(futures);

        // Save to cache
        final cacheData = jsonEncode(fetchedList.map((e) => {
          'name': e.name,
          'lastMessage': e.lastMessage,
          'image': e.image,
          'fev': e.fev,
          'conversationId': e.conversationId,
        }).toList());
        await prefs.setString('cachedUserList', cacheData);

        setState(() {
          list = fetchedList;
          isLoading = false;
        });

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

  Future<void> saveConversationId(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedConversationId', conversationId);
      print('Conversation ID saved: $conversationId');
    } catch (e) {
      print('Error saving conversation ID: $e');
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading && list.isEmpty // Only show loading if no cached data
          ? Center(child: CircularProgressIndicator(color: primaryColor1))
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load data', style: boldTextStyle()),
                      16.height,
                      ElevatedButton(
                        onPressed: fetchData,
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor1),
                        child: Text('Retry', style: TextStyle(color: white)),
                      ),
                    ],
                  ),
                )
              : list.isEmpty
                  ? Center(child: Text('No data available', style: secondaryTextStyle()))
                  : RefreshIndicator(
                      onRefresh: fetchData,
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          EAForYouModel data = list[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: appStore.isDarkModeOn ? Colors.grey[850] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                commonCachedNetworkImage(
                                  data.image,
                                  fit: BoxFit.cover,
                                  height: 60,
                                  width: 60,
                                ).cornerRadiusWithClipRRect(30),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.name ?? 'Unknown', style: boldTextStyle(size: 18)),
                                    4.height,
                                    Text(
                                      data.lastMessage ?? 'No messages yet',
                                      style: secondaryTextStyle(size: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                            ).paddingAll(8),
                          ).onTap(() {
                            String? fullname = list[index].name;
                            String? conversationId = list[index].conversationId;
                            if (conversationId != null) {
                              saveConversationId(conversationId);
                              joinConversation(conversationId);
                            }
                            EAChattingScreen(name: fullname).launch(context);
                          });
                        },
                      ),
                    ),
    );
  }
}

class EAForYouModel {
  String? name;
  String? lastMessage;
  String? image;
  bool? fev;
  String? conversationId;

  EAForYouModel({
    this.name,
    this.lastMessage,
    this.image,
    this.fev,
    this.conversationId,
  });
}