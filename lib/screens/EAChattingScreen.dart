import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_prokit/utils/EAConstants.dart';
import 'package:event_prokit/utils/EAapp_widgets.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  List<EAMessageModel> msgListing = [];
  var personName = '';
  bool isLoading = true;
  bool hasError = false; // Track if an error occurred
  String? conversationId;
  late IO.Socket socket; // Socket.IO client instance
  bool isTyping = false; // Track if the other user is typing
  bool isOnline = false; // Track if the other user is online

  @override
  void initState() {
    super.initState();
    init();
    initializeSocket(); // Initialize Socket.IO
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
        isLoading = false;
      });
    }
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
      if (conversationId != null) {
        joinConversation(conversationId!); // Join the conversation room
      }
      socket.emit('userConnected', 'john_doe'); // Emit user connected event
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });

    // Listen for new messages in real-time
    socket.on('newMessage', (data) {
      print('New message received: $data');
      setState(() {
        msgListing.add(EAMessageModel(
          senderId: data['whosend'] == 'john_doe' ? EASender_id : EAReceiver_id,
          receiverId: data['whosend'] == 'john_doe' ? EAReceiver_id : EASender_id,
          msg: data['message'] as String?,
          time: DateFormat('hh:mm a').format(DateTime.parse(data['timestamp'] as String)),
          senderUsername: data['senderUsername'] as String?,
          receiverUsername: data['receiverUsername'] as String?,
          seen: data['seen'] as bool?,
        ));
      });
      // Scroll to the bottom after receiving a new message
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
    });

    // Listen for messages seen events in real-time
    socket.on('messagesSeen', (data) {
      print('Messages seen: $data');
      if (data['conversationId'] == conversationId) {
        setState(() {
          msgListing.where((msg) => msg.seen == false).forEach((msg) {
            msg.seen = true;
          });
        });
      }
    });

    // Listen for typing events
    socket.on('typing', (data) {
      if (data['conversationId'] == conversationId && data['user'] != 'john_doe') {
        setState(() {
          isTyping = data['isTyping'] as bool;
        });
      }
    });

    // Listen for online users
    socket.on('onlineUsers', (users) {
      setState(() {
        isOnline = (users as List).contains(widget.name);
      });
    });
  }

  // Function to join a conversation room
  void joinConversation(String conversationId) {
    socket.emit('joinConversation', conversationId);
    print('Joined conversation: $conversationId');
  }

  // Function to emit typing event
  void onTyping(String value) {
    socket.emit('typing', {
      'conversationId': conversationId,
      'user': 'john_doe', // Replace with actual user
      'isTyping': value.isNotEmpty,
    });
  }

  // Function to fetch chat messages from the backend using the conversationId
  Future<void> fetchChatMessages() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.180.25:4000/api/messages/conversation/$conversationId'),
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

        // Mark messages as seen
        await markMessagesAsSeen();
      } else {
        print('Failed to load messages: ${response.statusCode}');
        setState(() {
          isLoading = false;
          hasError = true;
        });
        toast('Failed to load messages. Please try again.');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
      toast('An error occurred while fetching messages. Please try again.');
    }
  }

  // Function to send a message to the backend
  Future<void> sendClick() async {
    if (msgController.text.trim().isNotEmpty && conversationId != null) {
      hideKeyboard(context);

      // Prepare the payload
      final payload = {
        'conversationId': conversationId,
        'senderUsername': 'jane_smith', // Hardcoded as per your example
        'receiverUsername': widget.name, // Use the receiver's name
        'message': msgController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.180.25:4000/api/messages'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Message sent successfully: ${response.body}');
          msgController.text = ''; // Clear the input field
          // The new message will be added via Socket.IO 'newMessage' event
        } else {
          print('Failed to send message: ${response.statusCode}');
          toast('Failed to send message. Please try again.');
        }
      } catch (e) {
        print('Error sending message: $e');
        toast('An error occurred while sending the message. Please try again.');
      }

      FocusScope.of(context).requestFocus(msgFocusNode);
      setState(() {});
    } else {
      if (conversationId == null) {
        print('No conversation ID available to send message');
        toast('No conversation selected. Please try again.');
      }
      FocusScope.of(context).requestFocus(msgFocusNode);
    }
  }

  // Function to mark messages as seen
  Future<void> markMessagesAsSeen() async {
    if (conversationId == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.180.25:4000/api/messages/seen'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversationId': conversationId,
          'receiverUsername': 'john_doe', // Replace with actual receiver username
        }),
      );

      if (response.statusCode == 200) {
        print('Messages marked as seen');
      } else {
        print('Failed to mark messages as seen: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking messages as seen: $e');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    socket.disconnect(); // Disconnect Socket.IO when the screen is disposed
    msgController.dispose();
    scrollController.dispose();
    msgFocusNode.dispose();
    super.dispose();
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
        titleWidget: Row(
          children: [
            Text(widget.name!, style: boldTextStyle(color: Colors.white)),
            8.width,
            if (isOnline)
              Icon(Icons.circle, color: Colors.green, size: 10),
          ],
        ),
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
              : hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Failed to load messages', style: boldTextStyle()),
                          16.height,
                          ElevatedButton(
                            onPressed: fetchChatMessages, // Retry fetching messages
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : conversationId == null
                      ? Center(child: Text('No conversation selected'))
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(color: context.cardColor),
                          child: Column(
                            children: [
                              Expanded(
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
                              if (isTyping)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('${widget.name} is typing...', style: secondaryTextStyle()),
                                      8.width,
                                      SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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
                    onChanged: onTyping, // Emit typing event when the user types
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