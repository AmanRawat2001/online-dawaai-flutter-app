import 'package:flutter/material.dart';
import 'package:onlinedawai/api/product_search_api.dart';
import 'package:onlinedawai/api/singleproduct_api.dart';
import 'package:onlinedawai/features/home/model/product_detail_model.dart';
import 'package:onlinedawai/features/medicines/widgets/product_list_widget.dart';

class ShowallMedicinesScreen extends StatefulWidget {
  final String query;
  const ShowallMedicinesScreen({super.key, required this.query});

  @override
  State<ShowallMedicinesScreen> createState() => _ShowallMedicinesScreenState();
}

class _ShowallMedicinesScreenState extends State<ShowallMedicinesScreen> {
  final ProductSearchApi _productService = ProductSearchApi();
  final SingleproductApi _singleproductApi = SingleproductApi();

  List<dynamic> _productList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _productService.showAllSearchProduct(widget.query);
      setState(() {
        _productList = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading products: $e';
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines for: ${widget.query}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _productList.isEmpty
                  ? Center(child: Text('No products found'))
                  : ProductListWidget(
                      productList: _productList,
                      onProductTap: _showProductDetails,
                    ),
    );
  }
}
