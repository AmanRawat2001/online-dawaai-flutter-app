import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:onlinedawai/utils/token_storage.dart';
import 'package:onlinedawai/api/order_store_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cart;
  const CheckoutScreen(
      {super.key, required this.totalAmount, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Function to collect form data and send it to API
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      // Collect data from the text fields
      Map<String, String> shippingInfo = {
        'shipping_name':
            "${_firstNameController.text} ${_lastNameController.text}",
        'shipping_email': _emailController.text,
        'shipping_phone': _phoneController.text,
        'shipping_address':
            "${_addressController.text},${_cityController.text},${_stateController.text},${_countryController.text}",
        'shipping_code': _pincodeController.text,
        'amount': widget.totalAmount.toString(),
        'cart': jsonEncode(widget.cart),
      };
      try {
        String? token = await TokenStorage.getToken();
        if (token == null) {
          throw Exception("User is not authenticated.");
        }
        final apiResponse =
            await OrderStoreApi().orderstore(shippingInfo, token);
        if (apiResponse != null && apiResponse['status'] == 'success') {
          setState(() {
            _isSubmitting = false;
          });

          // Clear the cart from secure storage
          await _secureStorage.delete(key: 'cart');
          widget.cart.clear();

          // Show success dialog
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Order Placed'),
                content: Text('Your order has been placed successfully.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            _isSubmitting = false;
          });

          String errorMessage = apiResponse?['message'] ??
              'Failed to place the order. Please try again.';
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        setState(() {
          _isSubmitting = false;
        });

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('$error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Helper function to build text fields with validation
  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {int maxLines = 1,
      bool isNumeric = false,
      int? minLength,
      int? maxLength}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumeric
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : null,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (isNumeric) {
          if (minLength != null && value.length < minLength) {
            return 'Please enter a valid $label with $minLength digits.';
          }
          if (maxLength != null && value.length > maxLength) {
            return 'Please enter a valid $label with $maxLength digits.';
          }
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Automatically convert email input to lowercase
    _emailController.addListener(() {
      String currentText = _emailController.text;
      if (currentText != currentText.toLowerCase()) {
        _emailController.text = currentText.toLowerCase();
        _emailController.selection = TextSelection.fromPosition(
            TextPosition(offset: _emailController.text.length));
      }
    });
  }

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    // Regex for basic email validation
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the total amount
                Text(
                  "Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 20),

                // Fields for user data collection
                _buildTextField(
                    'First Name', Icons.person, _firstNameController),
                SizedBox(height: 20),
                _buildTextField('Last Name', Icons.person, _lastNameController),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, size: 20),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 1.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),
                _buildTextField('Phone', Icons.phone, _phoneController,
                    isNumeric: true, minLength: 10, maxLength: 10),
                SizedBox(height: 20),
                _buildTextField(
                    'Address', Icons.location_on, _addressController,
                    maxLines: 3),
                SizedBox(height: 20),
                _buildTextField('City', Icons.location_city, _cityController),
                SizedBox(height: 20),
                _buildTextField('State', Icons.location_city, _stateController),
                SizedBox(height: 20),
                _buildTextField(
                    'Pincode', Icons.location_on, _pincodeController,
                    isNumeric: true, minLength: 6, maxLength: 6),
                SizedBox(height: 20),
                _buildTextField(
                    'Country', Icons.location_city, _countryController),
                SizedBox(height: 20),

                // Submit button
                _isSubmitting
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          'Place Order',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
