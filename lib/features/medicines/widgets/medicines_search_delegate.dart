import 'package:flutter/material.dart';
import 'package:onlinedawai/api/product_search_api.dart';
import 'package:onlinedawai/api/singleproduct_api.dart';
import 'dart:async';
import 'package:onlinedawai/features/home/model/product_detail_model.dart';
import 'package:onlinedawai/features/medicines/screens/showall_medicines_screen.dart';

class MedicinesSearchDelegate extends StatefulWidget {
  const MedicinesSearchDelegate({super.key});

  @override
  State<MedicinesSearchDelegate> createState() => _MedicinesSearchDelegate();
}

class _MedicinesSearchDelegate extends State<MedicinesSearchDelegate> {
  final TextEditingController _searchController = TextEditingController();
  final ProductSearchApi _productSearchApi = ProductSearchApi();
  final SingleproductApi _singleproductApi = SingleproductApi();

  Timer? _debounce;
  List<dynamic> _productList = [];
  String _currentQuery = ''; // Store the current search query

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        setState(() {
          _currentQuery = query; // Store the query when it's changed
        });
        try {
          var results = await _productSearchApi.searchProducts(query);
          setState(() {
            _productList = results;
          });
          _showSearchResultsModal();
        } catch (e) {
          // ignore: avoid_print
          print('Error searching products: $e');
        }
      } else {
        setState(() {
          _productList.clear();
        });
      }
    });
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

  void _showSearchResultsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom AppBar with BackButton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        "Search Results",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      // Empty container for alignment
                      Container(width: 24),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_productList.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _productList.length,
                      itemBuilder: (context, index) {
                        var product = _productList[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(
                              product['product_image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              product['product_name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹${product['total_amount']?.toDouble()}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '₹${product['product_price']?.toDouble()}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '${product['product_discount']} off',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              _showProductDetails(context, product['id']);
                            },
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Center(
                      child: Text("No products found"),
                    ),
                  ],
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the API function to show all search products
                        _showAllSearchResults(_currentQuery);

                        // ShowallMedicinesScreen(query: _currentQuery);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text(
                        "Show All",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllSearchResults(String query) {
    // Perform the search again or show a new screen with all the results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowallMedicinesScreen(query: _currentQuery),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        border: InputBorder.none,
      ),
      onChanged: _onSearchChanged,
    );
  }
}
