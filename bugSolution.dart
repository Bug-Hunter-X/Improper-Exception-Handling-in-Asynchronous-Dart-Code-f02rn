```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> fetchData() async {
  try {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Instead of throwing a generic Exception, throw a custom exception with details.
      throw HttpException('Failed to load data: ${response.statusCode}', response.body);
    }
  } on SocketException catch (e) {
    // Handle network errors specifically.
    throw NetworkException('Network Error: ${e.message}');
  } on FormatException catch (e) {
    //Handle JSON decoding errors specifically.
    throw DataFormatException('Invalid JSON data: ${e.message}');
  } on HttpException catch (e) {
    //Handle HTTP errors specifically.
    rethrow; // Rethrow to allow higher level handling
  } catch (e) {
    // Catch any other unexpected errors.
    throw UnexpectedException('An unexpected error occurred: ${e.toString()}');
  }
}

// Custom Exception classes for better error handling
class HttpException implements Exception {
  final String message;
  final String? responseBody; //Add response body for more context

  HttpException(this.message, this.responseBody);
  @override
  String toString() => 'HttpException: $message, Response: $responseBody';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class DataFormatException implements Exception {
  final String message;
  DataFormatException(this.message);
  @override
  String toString() => 'DataFormatException: $message';
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
  @override
  String toString() => 'UnexpectedException: $message';
}
```