import 'package:flutter/material.dart';

class CartItemList extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final Map<int, Map<String, dynamic>> productDetails;
  final Map<int, bool> loadingProduct;
  final Future<void> Function(int) fetchProductDetails;
  final Future<void> Function(int) decreaseQuantity;
  final Future<void> Function(int) increaseQuantity;
  final Future<void> Function(int) removeItem;

  const CartItemList({
    required this.cart,
    required this.productDetails,
    required this.loadingProduct,
    required this.fetchProductDetails,
    required this.decreaseQuantity,
    required this.increaseQuantity,
    required this.removeItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final item = cart[index];
        final productId = item['id'];

        if (productDetails[productId] == null &&
            !loadingProduct.containsKey(productId)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fetchProductDetails(productId);
          });
        }

        return ListTile(
          title: Text(
              productDetails[productId]?['product_name'] ?? 'Product Details'),
          subtitle: Text(
              'Quantity: ${item['quantity']} x ₹${productDetails[productId]?['total_amount']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Increase button
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => increaseQuantity(index),
              ),
              // Decrease button
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => decreaseQuantity(index),
              ),
              // Delete button
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => removeItem(index),
              ),
            ],
          ),
          onTap: () {
            if (productDetails[productId] != null) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      productDetails[productId]?['product_name'] ??
                          'Product Details',
                    ),
                    content: loadingProduct[productId] == true
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  productDetails[productId]?['product_image'] ??
                                      '',
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                    'Name: ${productDetails[productId]?['product_name']}'),
                                Text(
                                    'Price: ₹${productDetails[productId]?['product_price']}'),
                                Text(
                                    'Discount: ${productDetails[productId]?['product_discount']}'),
                                Text(
                                    'After Discount: ₹${productDetails[productId]?['total_amount']}'),
                              ],
                            ),
                          ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
