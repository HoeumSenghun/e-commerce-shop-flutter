import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('Loading products from Supabase...');

      final response = await supabase
          .from('products')
          .select('*')
          .order('created_at', ascending: false);

      print('Products response: $response');

      _products = (response as List)
          .map((product) => Product.fromJson(product))
          .toList();

      print('Loaded ${_products.length} products');
    } catch (e) {
      print('Error loading products: $e');
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await supabase
          .from('categories')
          .select('*')
          .order('name');

      print('Categories loaded: ${response.length}');
    } catch (e) {
      print('Error loading categories: $e');
    }
  }
}