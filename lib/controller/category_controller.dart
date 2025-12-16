import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variable.dart';
import 'package:vendor_app/models/category.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class CategoryController {
  


  Future<void> deleteCategories({
    required List<String> ids,
    required context,
  }) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/delete-categories"),
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
      print("Erroe deleting categories: $e");
    }
  }


  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/get-categories'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      print("sajdkfhasdkjfhaskdlfhas");
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Category> categories = data
            .map((category) => Category.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories $e');
    }
  }
}
