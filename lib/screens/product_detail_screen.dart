import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import 'package:intl/intl.dart';
import 'checkout_form_screen.dart'; // ⬅️ pastikan sudah ada import ini

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  void addToCart(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    cart.add(json.encode(product.toJson()));
    await prefs.setStringList('cart', cart);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
    );
  }

  void buyNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutFormScreen(
          cart: [product],
          total: product.price.toDouble(),
        ),
      ),
    );
  }

  String formatRupiah(num number) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: const Color(0xFF8B5E3C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(product.price),
              style: const TextStyle(fontSize: 18, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star_border, color: Colors.amber, size: 20),
                SizedBox(width: 6),
                Text("4.0", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Deskripsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => addToCart(context),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Tambah ke Keranjang"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => buyNow(context),
                    icon: const Icon(Icons.flash_on),
                    label: const Text("Beli Sekarang"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
