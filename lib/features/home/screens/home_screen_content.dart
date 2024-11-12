import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

class HomeScreenContentState extends State<HomeScreenContent>
    with WidgetsBindingObserver {
  List<dynamic> banners = [];
  List<dynamic> featuredProducts = [];
  List<dynamic> sliders = [];
  List<dynamic> hotDeals = [];
  List<dynamic> specialOffers = [];
  List<dynamic> specialDeals = [];
  List<dynamic> titles = [];

  bool isLoading = true;
  String? errorMessage;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Add observer to listen for app lifecycle changes
    _fetchData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when the widget is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // The app is paused or goes into the background
      _clearCache();
    }
  }

  Future<void> _clearCache() async {
    // Clear cached data when the app is paused (i.e., when going to the background)
    await _secureStorage.delete(key: 'banners');
    await _secureStorage.delete(key: 'featuredProducts');
    await _secureStorage.delete(key: 'sliders');
    await _secureStorage.delete(key: 'hotDeals');
    await _secureStorage.delete(key: 'specialOffers');
    await _secureStorage.delete(key: 'specialDeals');
    await _secureStorage.delete(key: 'titles');
  }

  Future<void> _fetchData() async {
    try {
      // Check if data is available in secure storage
      String? cachedBanners = await _secureStorage.read(key: 'banners');
      String? cachedFeatured =
          await _secureStorage.read(key: 'featuredProducts');
      String? cachedSliders = await _secureStorage.read(key: 'sliders');
      String? cachedHotDeals = await _secureStorage.read(key: 'hotDeals');
      String? cachedSpecialOffers =
          await _secureStorage.read(key: 'specialOffers');
      String? cachedSpecialDeals =
          await _secureStorage.read(key: 'specialDeals');
      String? cachedTitles = await _secureStorage.read(key: 'titles');

      if (cachedBanners != null &&
          cachedFeatured != null &&
          cachedSliders != null &&
          cachedHotDeals != null &&
          cachedSpecialOffers != null &&
          cachedSpecialDeals != null &&
          cachedTitles != null) {
        // Use cached data if available
        setState(() {
          banners = List.from(json.decode(cachedBanners));
          featuredProducts = List.from(json.decode(cachedFeatured));
          sliders = List.from(json.decode(cachedSliders));
          hotDeals = List.from(json.decode(cachedHotDeals));
          specialOffers = List.from(json.decode(cachedSpecialOffers));
          specialDeals = List.from(json.decode(cachedSpecialDeals));
          titles = List.from(json.decode(cachedTitles));

          isLoading = false;
        });
      } else {
        // No cached data, fetch from API
        final fetchedBanners = await fetchBrands();
        final fetchedFeatured = await fetchFeatured();
        final fetchedSliders = await fetchSliders();
        final fetchedHotDeals = await fetchHotDeals();
        final fetchedSpecialOffers = await fetchSpecialOffer();
        final fetchedSpecialDeals = await fetchSpecialDeals();
        final fetchedTitles = await fetchTitles();

        // Cache the fetched data for later use
        await _secureStorage.write(
            key: 'banners', value: json.encode(fetchedBanners));
        await _secureStorage.write(
            key: 'featuredProducts', value: json.encode(fetchedFeatured));
        await _secureStorage.write(
            key: 'sliders', value: json.encode(fetchedSliders));
        await _secureStorage.write(
            key: 'hotDeals', value: json.encode(fetchedHotDeals));
        await _secureStorage.write(
            key: 'specialOffers', value: json.encode(fetchedSpecialOffers));
        await _secureStorage.write(
            key: 'specialDeals', value: json.encode(fetchedSpecialDeals));
        await _secureStorage.write(
            key: 'titles', value: json.encode(fetchedTitles));

        // Update UI with fetched data
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
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary,
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
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
              SizedBox(height: 20),
              BannerModel(banners: banners),
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
