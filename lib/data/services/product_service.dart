import '../api/loginapi.dart';
import '../models/product_model.dart';

class ProductService {
  final ApiClient apiClient;

  ProductService(this.apiClient);

  Future<List<ProductModel>> getAllProducts() async {
    final response = await apiClient.getData('/products');

    final List products = response.data['products'];

    return products.map((e) => ProductModel.fromJson(e)).toList();
  }
}
