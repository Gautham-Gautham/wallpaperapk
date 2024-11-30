import 'dart:convert';
import 'package:http/http.dart' as http;

import '../photo_model.dart';

class PhotoService {
  static const String baseUrl = 'https://api.unsplash.com';
  static const String apiKey =
      'Au4qQm0sZznWJQ6-m92-TBZAMRNK5gFNIqAf4Vt5H98'; // Replace with your Unsplash API key

  Future<List<Photo>> fetchPhotos({int page = 1, int perPage = 30}) async {
    // // final response = await http.get(
    // //   Uri.parse(
    // //       '$baseUrl/photos?page=$page&per_page=$perPage&order_by=popular'),
    // //   headers: {
    // //     'Authorization': 'Client-ID $apiKey',
    // //     'Accept-Version': 'v1',
    // //   },
    // // );
    // final response = await http.get(
    //   Uri.parse('$baseUrl?page=$page&client_id=$apiKey'),
    // );

    final response = await http.get(
      Uri.parse(
          '$baseUrl/photos?page=$page&per_page=$perPage&order_by=popular'),
      headers: {
        'Authorization': 'Client-ID $apiKey',
        'Accept-Version': 'v1',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((photoJson) => Photo.fromJson(photoJson)).toList();
    } else {
      print('Failed to load photos. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load photos');
    }
  }

  Future<Photo> getPhotoDetails(String photoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photos/$photoId'),
      headers: {
        'Authorization': 'Client-ID $apiKey',
        'Accept-Version': 'v1',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Photo.fromJson(data);
    } else {
      throw Exception('Failed to load photo details');
    }
  }
}
