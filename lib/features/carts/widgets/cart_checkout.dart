import 'package:flutter/material.dart';
import 'package:onlinedawai/features/carts/screens/checkout_screen.dart';

class CartCheckout extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cart;

  const CartCheckout(
      {super.key, required this.totalAmount, required this.cart});

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
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // ignore: avoid_print
              print("Checkout button pressed${widget.totalAmount}");
              print("Cart items: ${widget.cart}");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    totalAmount: widget.totalAmount,
                    cart: widget.cart,
                  ),
                ),
              );
            },
            child: Text(
              'Checkout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
