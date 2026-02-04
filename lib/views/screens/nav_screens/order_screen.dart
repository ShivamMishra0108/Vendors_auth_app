import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/controller/order_controller.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/provider/order_provider.dart';
import 'package:vendor_app/provider/vendor_provider.dart';
import 'package:vendor_app/views/details/widgets/order_detail_scren.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
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
      } catch (e) {
        print("Error fetching orders $e ");
      }
    }
  }

  Future<void> _deleteOrder(String id) async {
    final OrderController _orderController = OrderController();

    try {
      await _orderController.deleteOrders(id: id, context: context);
      fetchOrders();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/cartb.png"),
              fit: BoxFit.cover,
            ),
          ),

          child: Stack(
            children: [
              Positioned(
                left: 360,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset("assets/icons/not.png", height: 25, width: 25),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 15,
                        width: 15,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            orders.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 60,
                top: 51,
                child: Text(
                  "My Cart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 51,
                child: Stack(
                  children: [
                    Image.asset("assets/icons/cart.png", height: 25, width: 25),
                  ],
                ),
              ),
              Positioned(
                left: 160,
                top: 51,
                child: SizedBox(
                  height: 38,
                  width: 180,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Your Order",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 13),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),

                      prefixIcon: Image.asset("assets/icons/search.png"),

                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: orders.isEmpty
          ? Center(child: Text("No Orders Found"))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Column(
                  children: [
                    ListTile(
                      title: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return OrderDetailScreen(order: order);
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  order.image,
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    order.productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(order.category),

                                  Text(
                                    "₹${order.productPrice}",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: order.processing
                                          ? Container(
                                              height: 14,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: Colors.blue,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Processing",

                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 14,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Canceled",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    order.delivered
                                        ? Text(
                                            "delivered",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 13,
                                            ),
                                          )
                                        : Text(
                                            "Not Delivered",
                                            style: TextStyle(
                                              color: Colors.pink,
                                              fontSize: 13,
                                            ),
                                          ),

                                    InkWell(
                                      onTap: () {
                                        _deleteOrder(order.id);
                                      },
                                      child: Image.asset(
                                        "assets/icons/delete.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
