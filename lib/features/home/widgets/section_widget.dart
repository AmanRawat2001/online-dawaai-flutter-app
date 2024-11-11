import 'package:flutter/material.dart';

Widget buildSection(
    String title,
    List<dynamic> items,
    BuildContext context,
    Widget Function(
            BuildContext, String, double, String, String, double, String, int)
        buildItemTile) {
  if (items.isEmpty) {
    return SizedBox.shrink();
  }
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        items.isEmpty
            ? CircularProgressIndicator()
            : buildItemList(items, context, buildItemTile),
      ],
    ),
  );
}

Widget buildItemList(
    List<dynamic> items,
    BuildContext context,
    Widget Function(
            BuildContext, String, double, String, String, double, String, int)
        buildItemTile) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return buildItemTile(
          context,
          item['product_name'],
          item['total_amount'].toDouble(),
          item['product_image'],
          item['product_package'],
          item['product_price'].toDouble(),
          item['product_discount'],
          item['id'], // Pass the product ID here
        );
      },
    ),
  );
}
