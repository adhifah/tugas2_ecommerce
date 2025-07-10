import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'dart:convert';
import 'account_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final service = ProductService();
    final data = await service.fetchProducts();
    setState(() {
      products = data;
      filteredProducts = data;
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() => filteredProducts = products);
    } else {
      setState(() {
        filteredProducts = products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    cart.add(json.encode(product.toJson()));
    prefs.setStringList('cart', cart);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5E3C),
        title: const Text('Panshop'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AccountScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                product.image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                Icon(Icons.star_half, size: 14, color: Colors.amber),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                            child: Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                                  .format(product.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => addToCart(product),
                                icon: const Icon(Icons.add_shopping_cart, size: 16),
                                label: const Text('Add'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B5E3C),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
