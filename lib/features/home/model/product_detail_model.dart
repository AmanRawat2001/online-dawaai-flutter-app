import 'package:flutter/material.dart';

class ProductDetailsModel extends StatefulWidget {
  final Map<String, dynamic> productDetails;
  const ProductDetailsModel({super.key, required this.productDetails});

  @override
  State<ProductDetailsModel> createState() => _ProductDetailsModelState();
}

class _ProductDetailsModelState extends State<ProductDetailsModel> {
  int quantity = 1;
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
                    fontSize: 22,
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
                    'Company: ${productDetails['company']['company_name']}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${productDetails['category']['category_name']}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'SubCategory: ${productDetails['subcategory']['sub_category_name']}',
                    style: TextStyle(
                        fontSize: 14,
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
                  onPressed: () {
                    print('Added $quantity of ${productDetails['id']} to cart');
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
