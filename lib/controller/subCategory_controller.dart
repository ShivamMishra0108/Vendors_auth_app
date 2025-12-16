import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variable.dart';
import 'package:vendor_app/models/subCategory.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoryByCategory(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/get-categories/$categoryName/get-subcategories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("SubCategoris not found");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("SubCategoris not found");
        return [];
      } else {
        print("Failed to fetch subCategories");
        return [];
      }
    } catch (e) {
      print("Errr fetching SubCategories: $e");
      return [];
    }
  }
}
