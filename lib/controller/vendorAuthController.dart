
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variable.dart';

import 'package:vendor_app/models/vendor.dart';
import 'package:vendor_app/services/manage_http_response.dart';
import 'package:vendor_app/views/screens/main_vendor_screen.dart';

class Vendorauthcontroller {
  Future<void> signUpVendor({required String fullName,required String email, required String password, required context })async{
try {
  Vendor vendor = Vendor(
    id: '',
   fullName: fullName,
    email: email,
     state: '',
      city: '',
       locality: '', 
       role: '', 
       password: password);

  http.Response response = await http.post(Uri.parse('$uri/api/vendor/signup'),
  body: vendor.toJson(),
  headers: <String, String>{
    "Content-Type": "application/json; charset=UTF-8"
  }
  );
  
  manageHttpResponse(response: response, context: context, onSuccess: (){
    showSnackBar(context, "Vendor Account Created");
  });
} catch (e) {
  showSnackBar(context, '$e');
}
  }
  
  void showSnackBar(context, String s) {}

  Future<void> signInVendor({required String email, required String password, required context})async{
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/vendor/signin'),
      body: jsonEncode({"email":email, "password":password}),
      headers: <String, String>{
    "Content-Type": "application/json; charset=UTF-8"
  });
      manageHttpResponse(response: response, 
      context: context,
       onSuccess: (){
          showSnackBar(context, "LoggedIn Successfully");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainVendorScreen()),
           (route) => false);
       });
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }
}