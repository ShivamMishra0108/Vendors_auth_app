import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/controller/order_controller.dart';
import 'package:vendor_app/provider/earning_provider.dart';
import 'package:vendor_app/provider/order_provider.dart';
import 'package:vendor_app/provider/vendor_provider.dart';

class EarningScreen extends ConsumerStatefulWidget {
  const EarningScreen({super.key});

  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends ConsumerState<EarningScreen> {
    @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final vendor = ref.read(vendorProvider);

    print("FLUTTER vendorId: ${vendor?.id}");

    if (vendor != null) {
      OrderController orderController = OrderController();

      try {
        final orders = await orderController.loadOrders(vendorId: vendor.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(earningProvider.notifier).calculateEarnings(orders);
      } catch (e) {
        print("Error fetching orders $e ");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(earningProvider);
    final totalOrders = ref.watch(earningProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(vendor!.fullName[0].toUpperCase(),style: TextStyle(color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Text("Welcome! ${vendor.fullName}"),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Orders",style: TextStyle(color: Colors.grey, fontSize: 18)),

            Text("${totalOrders['totalOrders']}",
            style: TextStyle(
              fontSize: 36,
              color: Colors.blue,
              fontWeight: FontWeight.bold
            ),),

            Text("Total Earnings",style: TextStyle(color: Colors.grey, fontSize: 18)),

            Text("₹${totalEarnings['totalEarnings']}",
            style: TextStyle(
              fontSize: 36,
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),)
          ],
        )),
      ),
    );
  }
}