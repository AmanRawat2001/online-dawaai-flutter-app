import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:onlinedawai/api/singleproduct_api.dart';
import 'package:onlinedawai/features/carts/widgets/cart_checkout.dart';
import 'package:onlinedawai/features/carts/widgets/cart_item_lsit.dart';

class CartScreen extends StatefulWidget {
  final String token;
  const CartScreen({super.key, required this.token});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final SingleproductApi _singleproductApi = SingleproductApi();

  List<Map<String, dynamic>> cart = [];

  // Product data map
  Map<int, Map<String, dynamic>> productDetails = {};
  Map<int, bool> loadingProduct = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Load cart from SecureStorage
  Future<void> _loadCart() async {
    String? cartJson = await _secureStorage.read(key: 'cart');
    if (cartJson != null && cartJson.isNotEmpty) {
      setState(() {
        cart = List<Map<String, dynamic>>.from(json.decode(cartJson));
      });
    }
  }

  // Update cart in SecureStorage after modification
  Future<void> _updateCart() async {
    await _secureStorage.write(key: 'cart', value: json.encode(cart));
  }

  // Decrease quantity of an item
  Future<void> _decreaseQuantity(int index) async {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        cart.removeAt(index); // Remove item if quantity is 1
      }
    });
    _updateCart();
  }

  // Increase quantity of an item
  Future<void> _increaseQuantity(int index) async {
    setState(() {
      cart[index]['quantity']++;
    });
    _updateCart();
  }

  // Remove item from cart
  Future<void> _removeItem(int index) async {
    setState(() {
      cart.removeAt(index);
    });
    _updateCart();
  }

  // Fetch product details using API based on item id
  Future<void> _fetchProductDetails(int id) async {
    setState(() {
      loadingProduct[id] = true;
    });

    try {
      final productData = await _singleproductApi.fetchData(id);
      setState(() {
        productDetails[id] = productData;
        loadingProduct[id] = false;
      });
      // ignore: avoid_print
      print('Product details for ID $id: $productData');
    } catch (e) {
      setState(() {
        loadingProduct[id] = false;
      });
      // ignore: avoid_print
      print("Error fetching product data: $e");
    }
  }

  double _calculateTotalAmount() {
    double totalAmount = 0;

    for (var item in cart) {
      int productId = item['id'];
      double quantity = item['quantity'].toDouble();
      double productTotalAmount =
          productDetails[productId]?['total_amount']?.toDouble() ?? 0.0;

      totalAmount += productTotalAmount * quantity;
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: CartItemList(
                    cart: cart,
                    productDetails: productDetails,
                    loadingProduct: loadingProduct,
                    fetchProductDetails: _fetchProductDetails,
                    decreaseQuantity: _decreaseQuantity,
                    increaseQuantity: _increaseQuantity,
                    removeItem: _removeItem,
                  ),
                ),
                CartCheckout(
                  totalAmount: _calculateTotalAmount(),
                  cart: cart,
                ),
              ],
            ),
    );
  }
}
