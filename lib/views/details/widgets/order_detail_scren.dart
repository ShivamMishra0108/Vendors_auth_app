import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_app/controller/order_controller.dart';
import 'package:vendor_app/models/order.dart';
import 'package:vendor_app/provider/order_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;

  OrderDetailScreen({super.key, required this.order});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    // Watch the list of orders to trigger the automatic UI rebuilds
    final orders = ref.watch(orderProvider);

    // Find the updated order in the list
    final updatedOrder = orders.firstWhere(
      (o) => o.id == widget.order.id,
      orElse: () => widget.order,
    );

    return Scaffold(
      appBar: AppBar(
        // backgroundColor:  Color.fromARGB(255, 65, 194, 166),
        title: Text(
          "${widget.order.productName}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 130,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          widget.order.image,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              widget.order.productName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(widget.order.category),

                            Text(
                              "₹${widget.order.productPrice}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 65, 194, 166),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: updatedOrder.processing
                                  ? Container(
                                      height: 14,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Color.fromARGB(
                                          255,
                                          65,
                                          194,
                                          166,
                                        ),
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
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          " Canceled",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            updatedOrder.delivered
                                ? Container(
                                    height: 14,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Color.fromARGB(255, 65, 168, 194),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Delivered",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Not Delivered!",
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 13,
                                    ),
                                  ),

                            SizedBox(height: 10),

                            Image.asset(
                              "assets/icons/delete.png",
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 360,
                  height: 150,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 300,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -1,
                                left: -1,
                                child: SizedBox(
                                  width: 219,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 114,
                                          child: Text(
                                            "Delivery Address: ",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 114,
                                          child: Text(
                                            "${widget.order.locality}, ${widget.order.city}, ${widget.order.state}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "To: ${widget.order.fullName}",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Order ID: ${widget.order.id}",
                                          style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF7F5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Image.network(
                                          height: 26,
                                          width: 26,
                                          'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(padding: const EdgeInsets.all(8.0), child: Divider()),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mode of Payment:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      // Text(
                      //   "${CheckoutScreen.selectedPayment}",
                      //   style: TextStyle(fontSize: 18),
                      // ),
                      SizedBox(height: 10),
                      Text(
                        "Upload Invoice",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(padding: const EdgeInsets.all(8.0), child: Divider()),

              SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed:
                            updatedOrder.processing == false ||
                                updatedOrder.delivered
                            ? null
                            : () async {
                                final success = await orderController
                                    .updateDeliveryStatus(
                                      id: widget.order.id,
                                      context: context,
                                    );
                                if (success) {
                                  ref
                                      .read(orderProvider.notifier)
                                      .updateOrderState(
                                        widget.order.id,
                                        delivered: true,
                                      );
                                }
                                ;
                              },
                        child: Text(
                          updatedOrder.delivered == true
                              ? "Delivered"
                              : "Mark as Delivered?",
                          style: TextStyle(
                            color: updatedOrder.processing
                                ? Colors.green.shade600
                                : Colors.grey,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed:
                            updatedOrder.delivered ||
                                updatedOrder.processing == false
                            ? null
                            : () async {
                                final success = await orderController
                                    .cancelOrder(
                                      id: widget.order.id,
                                      context: context,
                                    );
                                if (success) {
                                  ref
                                      .read(orderProvider.notifier)
                                      .updateOrderState(
                                        widget.order.id,
                                        processing: false,
                                      );
                                }
                                ;
                              },
                        child: Text(
                          updatedOrder.processing ? "Cancel Order" : "Canceled",
                          style: TextStyle(
                            color: updatedOrder.delivered
                                ? Colors.grey
                                : Colors.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
