import 'package:flutter/material.dart';

// Track model to store music track details
class Track {
  final int id;
  final String title;
  final String artist;
  final String albumArtUrl;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
  });
}

class CongressPartnership extends StatefulWidget {
  const CongressPartnership({Key? key}) : super(key: key);

  @override
  _CongressPartnershipState createState() => _CongressPartnershipState();
}

class _CongressPartnershipState extends State<CongressPartnership> {
  // List of music tracks (using placeholder album art URLs)
  final List<Track> tracks = [
    Track(
      id: 1,
      title: "Head Above Water",
      artist: "Avril Lavigne",
      albumArtUrl: 'https://picsum.photos/200/200?random=1',
    ),
    Track(
      id: 2,
      title: "Journey EAST",
      artist: "Nemara J Radulovic",
      albumArtUrl: 'https://picsum.photos/200/200?random=2',
    ),
    Track(
      id: 3,
      title: "Erase The Pain",
      artist: "Paloma",
      albumArtUrl: 'https://picsum.photos/200/200?random=3',
    ),
    Track(
      id: 4,
      title: "YOURS",
      artist: "Beatrocks",
      albumArtUrl: 'https://picsum.photos/200/200?random=4',
    ),
    Track(
      id: 5,
      title: "Blind Tate",
      artist: "Unknown Artist",
      albumArtUrl: 'https://picsum.photos/200/200?random=5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // White background to match the app
        body: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Feed",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black, size: 28),
                    onPressed: () {
                      // TODO: Show more options
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("More options clicked")),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Music Feed List Section
            Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  Track track = tracks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        // Album Art
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50), // Circular album art
                          child: Image.network(
                            track.albumArtUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error, color: Colors.red));
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Track Title and Artist
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track.artist,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // More Options Icon
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.grey, size: 24),
                          onPressed: () {
                            // TODO: Show track options
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Options for ${track.title} clicked")),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}