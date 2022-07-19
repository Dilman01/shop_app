import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    print('Token in product: $token');
    // final url = Uri.https('flutter-update-16498-default-rtdb.firebaseio.com',
    //     '/products/$id.json?auth=$token');
    final url = Uri.parse(
        'https://flutter-update-16498-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(isFavorite);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }

// Future<void> toggleFavoriteStatus(String token, String userId) async {
//     final oldStatus = isFavorite;
//     isFavorite = !isFavorite;
//     notifyListeners();
//     final url =
//         'https://flutter-update.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
//     try {
//       final response = await http.put(
//         url,
//         body: json.encode(
//           isFavorite,
//         ),
//       );
//       if (response.statusCode >= 400) {
//         _setFavValue(oldStatus);
//       }
//     } catch (error) {
//       _setFavValue(oldStatus);
//     }
//   }

}
