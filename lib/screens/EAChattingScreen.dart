import 'package:event_prokit/utils/constants.dart';
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
  bool isLoading = true;
  bool hasError = false;
  String? conversationId;
  late IO.Socket socket;
  bool isTyping = false;
  bool isOnline = false;
  String? currentUserId; // Store the current user's ID

  @override
  void initState() {
    super.initState();
    init();
    initializeSocket();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    conversationId = prefs.getString('selectedConversationId');
    currentUserId = prefs.getString('userid'); // Get the current user's ID
    print('Retrieved Conversation ID: $conversationId');
    print('Current User ID: $currentUserId');

    if (conversationId != null && currentUserId != null) {
      await fetchChatMessages();
    } else {
      print('Missing conversation ID or user ID');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void initializeSocket() {
    socket = IO.io('http://49.13.202.68:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
      if (conversationId != null) {
        joinConversation(conversationId!);
      }
      socket.emit('userConnected', currentUserId); // Emit current user's ID
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });

    socket.on('newMessage', (data) {
      print('New message received: $data');
      setState(() {
        msgListing.add(EAMessageModel(
          senderId: data['senderUsername'] == currentUserId ? EASender_id : EAReceiver_id,
          receiverId: data['senderUsername'] == currentUserId ? EAReceiver_id : EASender_id,
          msg: data['message'] as String?,
          time: DateFormat('hh:mm a').format(DateTime.parse(data['timestamp'] as String)),
          senderUsername: data['senderUsername'] as String?,
          receiverUsername: data['receiverUsername'] as String?,
          seen: data['seen'] as bool?,
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

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

    socket.on('typing', (data) {
      if (data['conversationId'] == conversationId && data['user'] != currentUserId) {
        setState(() {
          isTyping = data['isTyping'] as bool;
        });
      }
    });

    socket.on('onlineUsers', (users) {
      setState(() {
        isOnline = (users as List).contains(widget.name);
      });
    });
  }

  void joinConversation(String conversationId) {
    socket.emit('joinConversation', conversationId);
    print('Joined conversation: $conversationId');
  }

  void onTyping(String value) {
    socket.emit('typing', {
      'conversationId': conversationId,
      'user': currentUserId,
      'isTyping': value.isNotEmpty,
    });
  }

  Future<void> fetchChatMessages() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://49.13.202.68:3000/api/messages/conversation/$conversationId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print('Fetched messages: $jsonData');

        setState(() {
          msgListing = jsonData.map((item) {
            return EAMessageModel(
              senderId: item['senderUsername'] == currentUserId ? EASender_id : EAReceiver_id,
              receiverId: item['senderUsername'] == currentUserId ? EAReceiver_id : EASender_id,
              msg: item['message'] as String?,
              time: DateFormat('hh:mm a').format(DateTime.parse(item['timestamp'] as String)),
              senderUsername: item['senderUsername'] as String?,
              receiverUsername: item['receiverUsername'] as String?,
              seen: item['seen'] as bool?,
            );
          }).toList();
          isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

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

  Future<void> sendClick() async {
    if (msgController.text.trim().isNotEmpty && conversationId != null && currentUserId != null) {
      hideKeyboard(context);

      final payload = {
        'conversationId': conversationId,
        'senderUsername': currentUserId, // Use current user's ID
        'receiverUsername': widget.name == 'Abrham' ? '67d5e72a00c420218a9bff36' : '67d5f09b00c420218a9bffad', // Adjust based on receiver
        'message': msgController.text.trim(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://49.13.202.68:3000/api/messages'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Message sent successfully: ${response.body}');
          msgController.text = '';
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
        toast('No conversation selected. Please try again.');
      }
      FocusScope.of(context).requestFocus(msgFocusNode);
    }
  }

  Future<void> markMessagesAsSeen() async {
    if (conversationId == null || currentUserId == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://49.13.202.68:3000/api/messages/seen'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversationId': conversationId,
          'receiverUsername': currentUserId,
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
    socket.disconnect();
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
                            onPressed: fetchChatMessages,
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
                                    var isMe = data.senderId == EASender_id;
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
                      hintText: widget.name!.isNotEmpty
                          ? 'Write to ${widget.name}'
                          : 'Type a message',
                      hintStyle: primaryTextStyle(),
                    ),
                    style: primaryTextStyle(),
                    onSubmitted: (s) {
                      sendClick();
                    },
                    onChanged: onTyping,
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

class EAMessageModel {
  int? senderId;
  int? receiverId;
  String? msg;
  String? time;
  String? senderUsername;
  String? receiverUsername;
  bool? seen;

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