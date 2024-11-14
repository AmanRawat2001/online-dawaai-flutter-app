import 'package:flutter/material.dart';

class ProductListModel extends StatelessWidget {
  final List<dynamic> productList;
  final String? nextPageUrl;
  final Function(String?) loadProducts;
  final ScrollController scrollController;
  final Function(BuildContext, int) showProductDetails;

  const ProductListModel({
    super.key,
    required this.productList,
    required this.nextPageUrl,
    required this.loadProducts,
    required this.scrollController,
    required this.showProductDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: productList.length + 1,
      itemBuilder: (context, index) {
        if (index == productList.length) {
          return nextPageUrl != null
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        }

        final product = productList[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              product['product_image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product['product_name']),
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
                Text('Company: ${product['company']['company_name']}'),
                Text(
                    'Category: ${product['category']['category_name'] ?? 'N/A'} '),
                Text(
                    'Subcategory: ${product['subcategory']?['sub_category_name'] ?? 'N/A'}'),
              ],
            ),
            onTap: () {
              showProductDetails(context, product['id']);
            },
          ),
        );
      },
    );
  }
}
