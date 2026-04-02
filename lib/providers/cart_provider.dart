import 'dart:convert';
import 'package:day5_app/data/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _items = [];

  List<CartModel> get items => _items;

  // أول ما الـ Provider يشتغل، هيجيب البيانات المتخزنة
  CartProvider() {
    loadCart();
  }

  // 1. إضافة منتج للسلة
  void addToCart(ProductModel product) {
    // بندور هل المنتج ده موجود قبل كده ولا لأ
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // لو موجود، زود الكمية
      _items[index].quantity += 1;
    } else {
      // لو مش موجود، ضيفه كعنصر جديد
      _items.add(CartModel(product: product));
    }
    _saveCart();
    notifyListeners();
  }

  // 2. تعديل الكمية (بالزيادة أو النقصان)
  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        // لو الكمية وصلت صفر، احذفه خالص
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  // 3. حذف منتج من السلة نهائياً
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  // 4. حساب السعر الإجمالي
  double get totalPrice {
    return _items.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  // 5. حساب عدد المنتجات الإجمالي (عشان نعرضه فوق أيقونة السلة مثلاً)
  int get totalItemsCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  // --- دوال الـ SharedPreferences ---

  // حفظ البيانات
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    // بنحول الليست كلها لنص JSON
    final String cartJson = jsonEncode(
      _items.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('cart_data', cartJson);
  }

  // استرجاع البيانات
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString('cart_data');

    if (cartJson != null) {
      // بنفك الـ JSON ونرجعه ليست من CartItemModel
      final List<dynamic> decodedData = jsonDecode(cartJson);
      _items = decodedData.map((item) => CartModel.fromJson(item)).toList();
      notifyListeners();
    }
  }
}
