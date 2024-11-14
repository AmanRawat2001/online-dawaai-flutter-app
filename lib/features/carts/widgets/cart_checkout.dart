import 'package:flutter/material.dart';

class CartCheckout extends StatefulWidget {
  final double totalAmount;

  const CartCheckout({super.key, required this.totalAmount});

  @override
  State<CartCheckout> createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ₹${widget.totalAmount.toStringAsFixed(2)}', // Use widget.totalAmount
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              // ignore: avoid_print
              print("Checkout button pressed${widget.totalAmount}");
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
