import 'package:flutter/material.dart';
import 'package:onlinedawai/api/home_api.dart'; // Import your API
import 'package:onlinedawai/features/home/model/slider_model.dart';
import 'package:onlinedawai/features/home/widgets/icon_tile_widget.dart';
import 'package:onlinedawai/features/home/widgets/product_tile_widget.dart';
import 'package:onlinedawai/features/home/widgets/section_widget.dart';
import 'package:onlinedawai/features/home/model/banner_model.dart'; // Import your model

class HomeScreenContent extends StatefulWidget {
  final String token;
  const HomeScreenContent({super.key, required this.token});

  @override
  HomeScreenContentState createState() => HomeScreenContentState();
}

class HomeScreenContentState extends State<HomeScreenContent> {
  List<dynamic> banners = [];
  List<dynamic> featuredProducts = [];
  List<dynamic> sliders = [];
  List<dynamic> hotDeals = [];
  List<dynamic> specialOffers = [];
  List<dynamic> specialDeals = [];
  List<dynamic> titles = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedBanners = await fetchBrands();
      final fetchedFeatured = await fetchFeatured();
      final fetchedSliders = await fetchSliders();
      final fetchedHotDeals = await fetchHotDeals();
      final fetchedSpecialOffers = await fetchSpecialOffer();
      final fetchedSpecialDeals = await fetchSpecialDeals();
      final fetchedTitles = await fetchTitles();

      setState(() {
        banners = fetchedBanners;
        featuredProducts = fetchedFeatured;
        sliders = fetchedSliders;
        hotDeals = fetchedHotDeals;
        specialOffers = fetchedSpecialOffers;
        specialDeals = fetchedSpecialDeals;
        titles = fetchedTitles;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        // Wrap the Column in SingleChildScrollView
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildIconTile(context, 'assets/images/medicines.png',
                      'Medicines', widget.token),
                  buildIconTile(context, 'assets/images/lab_test.png',
                      'Lab Tests', widget.token),
                  buildIconTile(context, 'assets/images/healthcare.png',
                      'Healthcare', widget.token),
                ],
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CircularProgressIndicator(),
                ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Error: $errorMessage',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (!isLoading && banners.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: BannerModel(banners: banners),
                ),
              buildSection(titles.isNotEmpty ? titles[0] : 'Featured Products',
                  featuredProducts, context, buildProductTile),
              SliderModel(sliders: sliders),
              buildSection(titles.length > 1 ? titles[1] : 'Hot Deals',
                  hotDeals, context, buildProductTile),
              buildSection(titles.length > 2 ? titles[2] : 'Special Offers',
                  specialOffers, context, buildProductTile),
              buildSection(titles.length > 3 ? titles[3] : 'Special Deals',
                  specialDeals, context, buildProductTile),
            ],
          ),
        ),
      ),
    );
  }
}
