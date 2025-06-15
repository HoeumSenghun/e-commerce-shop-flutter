import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class CartItem {
  final int id;
  final String userId;
  final int productId;
  final int quantity;
  final Product? product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      product: json['products'] != null ? Product.fromJson(json['products']) : null,
    );
  }

  double get totalPrice => (product?.price ?? 0) * quantity;
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      _items = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('cart_items')
          .select('*, products(*)')
          .eq('user_id', user.id);

      _items = (response as List)
          .map((item) => CartItem.fromJson(item))
          .toList();

      print('Loaded ${_items.length} cart items');
    } catch (e) {
      print('Error loading cart: $e');
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, {int quantity = 1}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    try {
      print('Adding product $productId to cart');
      
      // Check if item already exists
      final existingResponse = await supabase
          .from('cart_items')
          .select('*')
          .eq('user_id', user.id)
          .eq('product_id', productId)
          .maybeSingle();

      if (existingResponse != null) {
        // Update existing item
        final newQuantity = existingResponse['quantity'] + quantity;
        await supabase
            .from('cart_items')
            .update({'quantity': newQuantity})
            .eq('id', existingResponse['id']);
      } else {
        // Insert new item
        await supabase.from('cart_items').insert({
          'user_id': user.id,
          'product_id': productId,
          'quantity': quantity,
        });
      }

      await loadCart();
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    try {
      await supabase
          .from('cart_items')
          .update({'quantity': quantity})
          .eq('id', cartItemId);
      await loadCart();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      await supabase
          .from('cart_items')
          .delete()
          .eq('id', cartItemId);
      await loadCart();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> clearCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase
          .from('cart_items')
          .delete()
          .eq('user_id', user.id);
      _items.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
