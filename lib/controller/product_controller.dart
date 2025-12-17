import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variable.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/models/subCategory.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class ProductController {
  uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File> pickedImage,
    required context,
  }) async {

    if (pickedImage != null) {
      final cloudinary = CloudinaryPublic('dbum12hl4', "oeqnx1ce");
      List<String> images = [];

      for (var i = 0; i < pickedImage.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImage[i].path),
        );

        images.add(cloudinaryResponse.secureUrl);
      }

      if (category.isNotEmpty && subCategory.isNotEmpty) {
        Product product = Product(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );

         http.Response response = await http.post(
        Uri.parse('$uri/api/upload-products'),
        body: jsonEncode({
        'id': '',
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity.toDouble(),         
      'description': description.trim(),
     'category': category,
     'vendorId':vendorId,
     'fullName':fullName,
      'subCategory': subCategory,
      'images': images,
        }),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

       manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar2(context, "Product  Uploaded");
        },
      );
      }else{
        showSnackBar2(context, "Select Category");
      }
    } else {
      showSnackBar2(context, "select iImage");
    }
  }

  Future<List<Product>> loadProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/get-products'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Product> products = data
            .map((category) => Product.fromJson(category))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories $e');
    }
  }

  Future<void> deleteProducts({
    required List<String> ids,
    required context,
  }) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/delete-products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"ids": ids}),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar2(context, "Deleted Successfully");
        },
      );
    } catch (e) {
      print("Error deleting products: $e");
    }
  }
}
