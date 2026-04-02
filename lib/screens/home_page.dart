// import 'package:day5_app/data/api/loginapi.dart';
// import 'package:day5_app/data/models/product_model.dart';
import 'package:day5_app/providers/cart_provider.dart';
import 'package:day5_app/screens/cart_Screen.dart';
import 'package:flutter/material.dart';
// import '../data/services/product_service.dart';
// import '../data/services/category_service.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:day5_app/screens/login_screen.dart';
import '../providers/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchProductsAndCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // الكود بتاعك اللي بينقل لصفحة السلة يتحط هنا
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading || productProvider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = productProvider.products;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            product.thumbnail,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            MaterialButton(
                              color: Colors.blue.shade400,
                              onPressed: () {
                                // 1. استدعاء دالة الإضافة من الـ Provider
                                // لاحظ إننا بنمرر كائن الـ product الخاص بالعنصر الحالي في الـ GridView
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).addToCart(product);

                                // 2. إظهار رسالة صغيرة تأكد إن المنتج انضاف
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تمت الإضافة للسلة بنجاح!'),
                                    duration: Duration(
                                      seconds: 1,
                                    ), // بتختفي بسرعة
                                  ),
                                );
                              },
                              child: const Text(
                                'Add To Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
