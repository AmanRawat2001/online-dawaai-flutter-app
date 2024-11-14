import 'package:flutter/material.dart';

class ProductListWidget extends StatelessWidget {
  final List<dynamic> productList;
  final Function(BuildContext, int) onProductTap;

  const ProductListWidget({
    super.key,
    required this.productList,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: productList.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        var product = productList[index];
        return ListTile(
          leading: product['product_image'] != null
              ? Image.network(
                  product['product_image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.image_not_supported, size: 50),
          title: Text(
            product['product_name'] ?? 'Unnamed Product',
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Discount price: ₹${product['total_amount'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Price: ${product['product_price'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${product['product_discount']} off',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Text('Company: ${product['company']?['company_name'] ?? 'N/A'}'),
              Text(
                  'Category: ${product['category']?['category_name'] ?? 'N/A'}'),
              Text(
                  'Subcategory: ${product['subcategory']?['sub_category_name'] ?? 'N/A'}'),
            ],
          ),
          onTap: () => onProductTap(context, product['id']),
        );
      },
    );
  }
}
