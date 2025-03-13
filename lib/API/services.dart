import 'dart:convert';
import 'package:event_prokit/model/EAForYouModel.dart';
import 'package:http/http.dart' as http;

Future<List> fetchEvents() async {
  final response = await http.get(Uri.parse('http://192.168.198.49:3000/api/news'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);  // Decode JSON data
    // Map each element in the data to EAForYouModel and return as a List<EAForYouModel>
    return data.map((eventJson) => EAForYouModel.fromJson(eventJson)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}
