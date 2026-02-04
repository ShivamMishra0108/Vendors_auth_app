import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_app/global_variable.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/services/manage_http_response.dart';

class OrderController {
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendor/$vendorId'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();

        return orders;
      } else {
        throw Exception("Failed to load Orders");
      }
    } catch (e) {
      throw Exception("Error loading Orders $e");
    }
  }

  Future<void> deleteOrders({required String id, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/delete/$id"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar2(context, "Deleted Successfully");
        },
      );
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  Future<void> updateDeliveryStatus({
    required String id,
    required context,
  }) async {
    try {
      http.Response response =  await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },

        body: jsonEncode({"delivered": true}),
      );

      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar2(context, "Order Updated");
      });
    } catch (e) {
      showSnackBar2(context, e.toString());
    }
  }


  Future<void> cancelOrder({
    required String id,
    required context,
  }) async {
    try {
      http.Response response =  await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },

        body: jsonEncode({"processing": false}),
      );

      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar2(context, "Order Updated");
      });
    } catch (e) {
      showSnackBar2(context, e.toString());
    }
  }
}
