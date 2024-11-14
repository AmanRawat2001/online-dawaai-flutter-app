import 'package:flutter/material.dart';
import 'package:onlinedawai/api/all_medicines_api.dart';
import 'package:onlinedawai/features/home/model/product_detail_model.dart';
import 'package:onlinedawai/api/singleproduct_api.dart';
import 'package:onlinedawai/features/medicines/widgets/product_details_model.dart';

class MedicinescreenContent extends StatefulWidget {
  final String token;
  const MedicinescreenContent({super.key, required this.token});

  @override
  State<MedicinescreenContent> createState() => _MedicinescreenContentState();
}

class _MedicinescreenContentState extends State<MedicinescreenContent> {
  final AllMedicinesApi _productService = AllMedicinesApi();
  final SingleproductApi _singleproductApi = SingleproductApi();

  final List<dynamic> _productList = [];
  String? _nextPageUrl;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProducts(null); // Initial load of products
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // Function to load products from the API
  Future<void> _loadProducts(String? url) async {
    final response = await _productService.fetchProducts(url: url);
    setState(() {
      _productList.addAll(response['data']);
      _nextPageUrl = response['next_page_url'];
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_nextPageUrl != null) {
        _loadProducts(_nextPageUrl);
      }
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
      body: _productList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ProductListView(
              productList: _productList,
              nextPageUrl: _nextPageUrl,
              loadProducts: _loadProducts,
              scrollController: _scrollController,
              showProductDetails: _showProductDetails,
            ),
    );
  }
}
