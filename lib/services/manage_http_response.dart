import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  void showSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  try {
    final decoded = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        onSuccess();
        break;

      case 400:
      case 401:
      case 403:
        showSnackBar(context, decoded['msg'] ?? 'Invalid request');
        break;

      case 500:
        showSnackBar(context, decoded['error'] ?? 'Server error');
        break;

      default:
        showSnackBar(context, 'Unexpected error: ${response.statusCode}');
    }
  } catch (e) {
    // If JSON decoding fails or other error occurs
    showSnackBar(context, 'Something went wrong: $e');
  }
}
