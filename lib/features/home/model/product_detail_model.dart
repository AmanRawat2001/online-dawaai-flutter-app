import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProductDetailsModel extends StatefulWidget {
  final Map<String, dynamic> productDetails;
  const ProductDetailsModel({super.key, required this.productDetails});

  @override
  State<ProductDetailsModel> createState() => _ProductDetailsModelState();
}

class _ProductDetailsModelState extends State<ProductDetailsModel> {
  int quantity = 1;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isAddingToCart = false;

  Future<void> addToCart(
      Map<String, dynamic> productDetails, int quantity) async {
    setState(() {
      isAddingToCart = true;
    });
    String? cartJson = await _secureStorage.read(key: 'cart');
    List<Map<String, dynamic>> cart = [];
    if (cartJson != null && cartJson.isNotEmpty) {
      cart = List<Map<String, dynamic>>.from(json.decode(cartJson));
    }
    final existingProductIndex =
        cart.indexWhere((item) => item['id'] == productDetails['id']);

    if (existingProductIndex != -1) {
      setState(() {
        cart[existingProductIndex]['quantity'] += quantity;
      });
    } else {
      setState(() {
        cart.add({
          'id': productDetails['id'],
          'quantity': quantity,
        });
      });
    }

    await _secureStorage.write(key: 'cart', value: json.encode(cart));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Added ${productDetails['product_name']} to cart!')),
    );
    Navigator.pop(context); // This will close the modal

    setState(() {
      isAddingToCart = false;
    });
    print('Cart updated: $cart');
  }

  @override
  Widget build(BuildContext context) {
    final productDetails = widget.productDetails;

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    productDetails['product_image'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  productDetails['product_name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹${productDetails['total_amount']?.toDouble()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      '₹${productDetails['product_price']?.toDouble()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${productDetails['product_discount']} off',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(height: 8),
                Text(
                  productDetails['product_package'],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 10),
                if (productDetails.isNotEmpty) ...[
                  Text(
                    'Company: ${productDetails['company'] != null ? productDetails['company']['company_name'] : 'N/A'}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${productDetails['category'] != null ? productDetails['category']['category_name'] : 'N/A'}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Subcategory: ${productDetails['subcategory'] != null ? productDetails['subcategory']['sub_category_name'] : 'N/A'}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$quantity',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: isAddingToCart
                      ? null
                      : () {
                          addToCart(productDetails, quantity);
                        },
                  child: isAddingToCart
                      ? CircularProgressIndicator()
                      : Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
