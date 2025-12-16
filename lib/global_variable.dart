import 'package:flutter/material.dart';

String uri = 'http://192.168.29.49:3000';

void showSnackBar2(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

