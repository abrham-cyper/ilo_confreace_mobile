import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';

class ConferenceFeedScreen extends StatelessWidget {
  // JSON data for the conference feed with both images and videos
  final String feedJson = '''
  {
    "title": " 2025 ILO ",
    "posts": [
      {
        "mediaUrl": "https://example.com/post1.jpg",
        "mediaType": "image",
        "description": "Excited to announce the 2025 ILO Regional Conference! Discussing the future of work in the digital age. #ILORegional2025",
        "heightFactor": 1.2
      },
      {
        "mediaUrl": "https://v1.pinimg.com/videos/mc/expMp4/44/27/99/442799477c10f469cb01832bf304e1bb_t3.mp4",
        "mediaType": "video",
        "description": "Highlights from the climate resilience panel! The insights on green jobs were inspiring. 🌱 #ILORegional2025",
        "heightFactor": 1.5
      },
      {
        "mediaUrl": "https://example.com/post3.jpg",
        "mediaType": "image",
        "description": "Networking reception at the Garden Pavilion was a highlight! Great conversations and live music. 🎶 #ILORegional2025",
        "heightFactor": 1.0
      },
      {
        "mediaUrl": "https://v1.pinimg.com/videos/mc/expMp4/44/27/99/442799477c10f469cb01832bf304e1bb_t3.mp4",
        "mediaType": "video",
        "description": "Advocating for gender equality in the workplace at the ILO Conference. Let's close the gap! 💪 #ILORegional2025",
        "heightFactor": 1.3
      },
      {
        "mediaUrl": "https://example.com/post5.jpg",
        "mediaType": "image",
        "description": "Sharing insights on green jobs and sustainable economic transitions. 🌍 #ILORegional2025",
        "heightFactor": 1.1
      },
      {
        "mediaUrl": "https://v1.pinimg.com/videos/mc/expMp4/44/27/99/442799477c10f469cb01832bf304e1bb_t3.mp4",
        "mediaType": "video",
        "description": "Climate policy discussions at the ILO Conference were eye-opening! #ILORegional2025",
        "heightFactor": 1.4
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    // Parse JSON data
    final Map<String, dynamic> feedData = jsonDecode(feedJson);
    final String title = feedData['title'];
    final List<dynamic> posts = feedData['posts'];

    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // Light background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Company Branding
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  // Placeholder for company logo (replace with actual asset)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2A7C76),
                          Color(0xFF1A5C56),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "ILO",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black54),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Search tapped!")),
                    );
                  },
                ),
              ],
            ),
            // Pinterest-style Posts Section with Images and Videos
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2, // 2 columns like Pinterest
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: PostCard(
                      mediaUrl: post['mediaUrl'],
                      mediaType: post['mediaType'],
                      description: post['description'],
                      heightFactor: post['heightFactor'],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ],
        ),
      ),
    
    );
  }
}

class PostCard extends StatefulWidget {
  final String mediaUrl;
  final String mediaType;
  final String description;
  final double heightFactor;

  const PostCard({
    required this.mediaUrl,
    required this.mediaType,
    required this.description,
    required this.heightFactor,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        }).catchError((error) {
          print("Error initializing video: $error");
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              mediaUrl: widget.mediaUrl,
              mediaType: widget.mediaType,
              description: widget.description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media (Image or Video)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.mediaType == 'video'
                  ? _isVideoInitialized
                      ? Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 150 * widget.heightFactor,
                              child: VideoPlayer(_videoController!),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    _videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_videoController!.value.isPlaying) {
                                        _videoController!.pause();
                                      } else {
                                        _videoController!.play();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: double.infinity,
                          height: 150 * widget.heightFactor,
                          color: Colors.grey[300],
                          child: Center(child: CircularProgressIndicator()),
                        )
                  : Image.network(
                      widget.mediaUrl,
                      width: double.infinity,
                      height: 150 * widget.heightFactor,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 150 * widget.heightFactor,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ),
            // Post Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Description
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    maxLines: 2, // Limit to 2 lines to prevent overflow
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostDetailScreen extends StatefulWidget {
  final String mediaUrl;
  final String mediaType;
  final String description;

  const PostDetailScreen({
    required this.mediaUrl,
    required this.mediaType,
    required this.description,
  });

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _videoController = VideoPlayerController.network(widget.mediaUrl)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        }).catchError((error) {
          print("Error initializing video: $error");
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Back Button and Company Branding
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2A7C76),
                          Color(0xFF1A5C56),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Placeholder for company logo (replace with actual asset)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF2A7C76),
                                Color(0xFF1A5C56),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "ILO",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "2025 ILO Regional Conference",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Media and Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media (Image or Video)
                    FadeInUp(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.mediaType == 'video'
                            ? _isVideoInitialized
                                ? Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 400,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: IconButton(
                                            icon: Icon(
                                              _videoController!.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (_videoController!.value.isPlaying) {
                                                  _videoController!.pause();
                                                } else {
                                                  _videoController!.play();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 400,
                                    color: Colors.grey[300],
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                            : Image.network(
                                widget.mediaUrl,
                                width: double.infinity,
                                height: 400,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: double.infinity,
                                  height: 400,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Description
                    FadeInUp(
                      delay: Duration(milliseconds: 200),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}