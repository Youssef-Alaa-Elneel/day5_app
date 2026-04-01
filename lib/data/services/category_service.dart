import 'package:day5_app/data/api/loginapi.dart';

class CategoryService {
  final ApiClient apiClient;

  CategoryService(this.apiClient);

  Future<List<String>> getCategories() async {
    final response = await apiClient.getData('/products/categories');

    final data = response.data;
    print('Response type: ${data.runtimeType}');

    if (data is List) {
      print('First 5 items: ${data.take(5).toList()}');
    } else if (data is Map && data['categories'] != null) {
      print('Keys: ${data.keys}');
      print('First 5 categories: ${data['categories'].take(5).toList()}');
    } else {
      print('Unexpected response format: $data');
    }

    // رجع الـ list زي ما هو
    if (response.statusCode == 200) {
      if (data is List) {
        return List<String>.from(data.map((e) => e.toString()));
      } else if (data is Map && data['categories'] != null) {
        return List<String>.from(data['categories']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
