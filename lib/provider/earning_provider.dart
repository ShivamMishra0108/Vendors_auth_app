import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/order.dart';

class EarningProvider extends StateNotifier<Map<String, dynamic>> {
  // Constructor that initalizes with earnings  (0.0)
  EarningProvider() : super({'totalEarnings':0.0, 'totalOrders':0});

  // Method to calculate total earnings bases on delivery satus
  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;

    // Loop traverse in every order of the list of orders
    for (Order order in orders) {
      // Check if order has been delivered
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }

    // update the state with total earnings which will notify the listeners 
    state = {
      "totalEarnings":earnings,
      "totalOrders":orderCount
    };
  }
}

final earningProvider = StateNotifierProvider<EarningProvider,Map<String, dynamic>>((ref){
  return EarningProvider();
});