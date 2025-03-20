import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class EAYourCardScreen extends StatefulWidget {
  @override
  _EAYourCardScreenState createState() => _EAYourCardScreenState();
}

class _EAYourCardScreenState extends State<EAYourCardScreen> {
  List<CardModel> cardList = []; // List to store cards
  bool isLoading = true; // To show loading spinner
  String errorMessage = ''; // To show error message if something goes wrong

  @override
  void initState() {
    super.initState();
    fetchCards(); // Fetch cards when the screen loads
  }

  // Function to fetch cards from the API
  Future<void> fetchCards() async {
    setState(() {
      isLoading = true; // Show loading spinner
      errorMessage = ''; // Clear any previous error
    });

    try {
      // Replace this URL with your actual API endpoint
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/events'));

      if (response.statusCode == 200) {
        // If API call is successful, parse the JSON data
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          cardList = data.map((item) => CardModel.fromJson(item)).toList();
          isLoading = false; // Hide loading spinner
        });
      } else {
        // If API call fails, show error message
        setState(() {
          errorMessage = 'Failed to load cards';
          isLoading = false;
        });
      }
    } catch (e) {
      // If there's an error (e.g., no internet), show error message
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background color
      body: _buildBody(), // Build the main content
    );
  }

  // Function to build the main content of the screen
  Widget _buildBody() {
    // Show loading spinner if data is being fetched
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Simple loading spinner
      );
    }

    // Show error message if something went wrong
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red), // Error icon
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchCards, // Retry button to fetch data again
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show message if no cards are available
    if (cardList.isEmpty) {
      return const Center(
        child: Text(
          'No cards available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Show the list of cards
    return ListView.builder(
      padding: const EdgeInsets.all(16), // Add padding around the list
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        return _buildCardItem(cardList[index]); // Build each card
      },
    );
  }

  // Function to build a single card item
  Widget _buildCardItem(CardModel card) {
    return Card(
      elevation: 4, // Add shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.only(bottom: 16), // Space between cards
      child: Padding(
        padding: const EdgeInsets.all(16), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Image (if available)
            if (card.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  card.image!,
                  height: 150,
                  width: double.infinity, // Full width
                  fit: BoxFit.cover, // Cover the space
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10), // Space between image and text
            // Card Title
            Text(
              card.name ?? 'No Title', // Show 'No Title' if name is null
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Primary color for title
              ),
            ),
            const SizedBox(height: 5),
            // Card Price
            Text(
              'ETB ${card.price ?? 0}', // Show '0' if price is null
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Color for price
              ),
            ),
            const SizedBox(height: 5),
            // Card Description
            Text(
              card.note ?? 'No Description', // Show fallback if note is null
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            // View Details Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Add your action here, e.g., navigate to details screen
                  print('Tapped on ${card.name}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class to represent a card
class CardModel {
  String? name;
  String? image;
  int? price;
  String? note;

  CardModel({
    this.name,
    this.image,
    this.price,
    this.note,
  });

  // Factory method to create a CardModel from JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as int?,
      note: json['note'] as String?,
    );
  }
}