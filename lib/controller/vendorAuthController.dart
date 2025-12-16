
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variable.dart';

import 'package:vendor_app/models/vendor.dart';
import 'package:vendor_app/provider/vendor_provider.dart';
import 'package:vendor_app/services/manage_http_response.dart';
import 'package:vendor_app/views/screens/main_vendor_screen.dart';

final providerContainer = ProviderContainer();
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
    showSnackBar2(context, "Vendor Account Created");
  });
} catch (e) {
  showSnackBar2(context, '$e');
}
  }
  


  Future<void> signInVendor({required String email, required String password, required context})async{
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/vendor/signin'),
      body: jsonEncode({"email":email, "password":password}),
      headers: <String, String>{
    "Content-Type": "application/json; charset=UTF-8"
  });
      manageHttpResponse(response: response, 
      context: context,
       onSuccess: ()async{
        SharedPreferences preferences = await SharedPreferences.getInstance();

        //Extarct the auth token from the response body:
        String token = jsonDecode(response.body)['token'];

        //Store the auth tken in Shared Preferences:
        await preferences.setString('auth_token',token);

        // Extract the user data fomr backend as json:
        final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

        // Update the application state with user data using riverpod:
        providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

        // Store the user data in sharedPreferences:
        await preferences.setString('vendor', vendorJson);


          showSnackBar2(context, "LoggedIn Successfully");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainVendorScreen()),
           (route) => false);
       });
    } catch (e) {
      showSnackBar2(context, '$e');
    }
  }
}