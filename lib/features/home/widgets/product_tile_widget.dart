import 'package:flutter/material.dart';
import 'package:onlinedawai/features/home/model/product_detail_model.dart';
import 'package:onlinedawai/api/singleproduct_api.dart';

final SingleproductApi _singleproductApi = SingleproductApi();

Widget buildProductTile(
  BuildContext context,
  String productName,
  double price,
  String imageUrl,
  String package,
  double originalPrice,
  String discount,
  int productId,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
    child: GestureDetector(
      onTap: () {
        // Add navigation logic here
        print('Tapped on $productName');
        _showProductDetails(context, productId);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 0.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              productName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹$price',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '₹$originalPrice',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$discount% off',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              package,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showProductDetails(BuildContext context, int productId) {
  _singleproductApi.fetchData(productId).then((data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final productDetails = data;
        return ProductDetailsModel(productDetails: productDetails);
      },
    );
  }).catchError((error) {
    print("Failed to fetch data: $error");
  });
}
