import 'package:flutter/material.dart';
import '../data/services/product_service.dart';
import '../data/services/category_service.dart';
import '../data/models/product_model.dart';
import '../data/api/loginapi.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService(ApiClient());
  final CategoryService _categoryService = CategoryService(ApiClient());

  List<ProductModel> products = [];
  List<String> categories = [];
  bool isLoading = false;

  String selectedCategory = 'All';

  Future<void> fetchProductsAndCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await _productService.getAllProducts();
      categories = await _categoryService.getCategories();

      if (!categories.contains('All')) {
        categories.insert(0, 'All');
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void changeCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
