import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'dart:convert';

class EAChattingScreen extends StatefulWidget {
  final String? name;

  EAChattingScreen({this.name});

  @override
  EAChattingScreenState createState() => EAChattingScreenState();
}

class EAChattingScreenState extends State<EAChattingScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController msgController = TextEditingController();
  FocusNode msgFocusNode = FocusNode();
  List<EAMessageModel> msgListing = []; // Initialized as empty, populated by API
  var personName = '';
  bool isLoading = true; // To show loading state
  String? conversationId; // To store the retrieved conversationId

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // Retrieve conversationId from shared_preferences
    final prefs = await SharedPreferences.getInstance();
    conversationId = prefs.getString('selectedConversationId');
    print('Retrieved Conversation ID: $conversationId');

    if (conversationId != null) {
      await fetchChatMessages(); // Fetch messages and scroll to bottom
    } else {
      print('No conversation ID found in shared_preferences');
      setState(() {
        isLoading = false; // Stop loading if no conversationId is found
      });
    }
  }

  // Function to fetch chat messages from the backend using the conversationId
  Future<void> fetchChatMessages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.14:4000/api/messages/conversation/$conversationId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);

        setState(() {
          msgListing = jsonData.map((item) {
            return EAMessageModel(
              senderId: item['whosend'] == 'john_doe' ? EASender_id : EAReceiver_id,
              receiverId: item['whosend'] == 'john_doe' ? EAReceiver_id : EASender_id,
              msg: item['message'] as String?,
              time: DateFormat('hh:mm a').format(DateTime.parse(item['timestamp'] as String)),
              senderUsername: item['senderUsername'] as String?,
              receiverUsername: item['receiverUsername'] as String?,
              seen: item['seen'] as bool?,
            );
          }).toList();
          isLoading = false;
        });

        // Scroll to the bottom after loading messages
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      } else {
        print('Failed to load messages: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to send a message to the backend
  Future<void> sendClick() async {
    if (msgController.text.trim().isNotEmpty && conversationId != null) {
      hideKeyboard(context);

      // Prepare the payload
      final payload = {
        'conversationId': conversationId,
        'senderUsername': 'john_doe', // Hardcoded as per your example
        'receiverUsername': widget.name, // Use the receiver's name
        'message': msgController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.137.14:4000/api/messages'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Message sent successfully: ${response.body}');
          msgController.text = ''; // Clear the input field
          await fetchChatMessages(); // Refresh the message list
          // Scroll to the bottom after sending
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        } else {
          print('Failed to send message: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending message: $e');
      }

      FocusScope.of(context).requestFocus(msgFocusNode);
      setState(() {});
    } else {
      if (conversationId == null) {
        print('No conversation ID available to send message');
      }
      FocusScope.of(context).requestFocus(msgFocusNode);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        widget.name!,
        backWidget: IconButton(
          onPressed: () {
            finish(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        center: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : conversationId == null
                  ? Center(child: Text('No conversation selected'))
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(color: context.cardColor),
                      child: ListView.separated(
                        separatorBuilder: (_, i) => Divider(color: Colors.transparent),
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: msgListing.length,
                        padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 70),
                        itemBuilder: (_, index) {
                          EAMessageModel data = msgListing[index];
                          var isMe = data.senderId == EASender_id; // Align based on sender
                          return ChatMessageWidget1(isMe: isMe, data: data);
                        },
                      ),
                    ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: context.cardColor,
                boxShadow: defaultBoxShadow(),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: msgController,
                    focusNode: msgFocusNode,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration.collapsed(
                      hintText: personName.isNotEmpty
                          ? 'Write to ${widget.name}'
                          : 'Type a message',
                      hintStyle: primaryTextStyle(),
                    ),
                    style: primaryTextStyle(),
                    onSubmitted: (s) {
                      sendClick();
                    },
                  ).expand(),
                  IconButton(
                    icon: Icon(Icons.send, size: 25),
                    onPressed: () async {
                      await sendClick();
                    },
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

// Updated EAMessageModel to match API response
class EAMessageModel {
  int? senderId; // Matches EASender_id and EAReceiver_id
  int? receiverId;
  String? msg;
  String? time;
  String? senderUsername; // Added for API data
  String? receiverUsername; // Added for API data
  bool? seen; // Added for API data

  EAMessageModel({
    this.senderId,
    this.receiverId,
    this.msg,
    this.time,
    this.senderUsername,
    this.receiverUsername,
    this.seen,
  });
}

// Updated ChatMessageWidget1 for realistic display
class ChatMessageWidget1 extends StatelessWidget {
  final bool isMe;
  final EAMessageModel data;

  const ChatMessageWidget1({required this.isMe, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  data.msg ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                4.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.time ?? '',
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    if (isMe && data.seen != null) ...[
                      4.width,
                      Icon(
                        data.seen! ? Icons.done_all : Icons.done,
                        size: 16,
                        color: data.seen! ? Colors.white : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}