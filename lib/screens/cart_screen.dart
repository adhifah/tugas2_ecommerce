import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';
import 'checkout_form_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  Map<String, Map<String, dynamic>> groupedCart = {}; // id: {product, quantity}

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> raw = prefs.getStringList('cart') ?? [];

    Map<String, Map<String, dynamic>> temp = {};
    for (String item in raw) {
      final product = Product.fromJson(json.decode(item));
      if (temp.containsKey(product.id)) {
        temp[product.id]!['quantity'] += 1;
      } else {
        temp[product.id] = {'product': product, 'quantity': 1};
      }
    }

    setState(() {
      groupedCart = temp;
    });
  }

  void saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> allItems = [];

    groupedCart.forEach((_, value) {
      for (int i = 0; i < value['quantity']; i++) {
        allItems.add(json.encode((value['product'] as Product).toJson()));
      }
    });

    await prefs.setStringList('cart', allItems);
  }

  void increaseQty(String id) {
    setState(() {
      groupedCart[id]!['quantity'] += 1;
    });
    saveCart();
  }

  void decreaseQty(String id) {
    setState(() {
      if (groupedCart[id]!['quantity'] > 1) {
        groupedCart[id]!['quantity'] -= 1;
      } else {
        groupedCart.remove(id);
      }
    });
    saveCart();
  }

  double get total {
    double sum = 0;
    groupedCart.forEach((_, value) {
      sum += (value['product'] as Product).price * value['quantity'];
    });
    return sum;
  }

  void openCheckout() {
    final cartItems = groupedCart.values
        .expand((item) => List.generate(item['quantity'], (_) => item['product'] as Product))
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Text("Yakin ingin membayar total ${currencyFormatter.format(total)}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutFormScreen(
                    cart: cartItems,
                    total: total,
                    onCheckoutComplete: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('cart');
                      setState(() => groupedCart.clear());
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5E3C),
              foregroundColor: Colors.white,
            ),
            child: const Text("Bayar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B5E3C),
        elevation: 0,
      ),
      body: groupedCart.isEmpty
          ? const Center(
        child: Text(
          'Keranjang kosong',
          style: TextStyle(fontSize: 16),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView(
              children: groupedCart.entries.map((entry) {
                final product = entry.value['product'] as Product;
                final qty = entry.value['quantity'];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(currencyFormatter.format(product.price)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => decreaseQty(product.id),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('$qty'),
                                IconButton(
                                  onPressed: () => increaseQty(product.id),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => decreaseQty(product.id),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: ${currencyFormatter.format(total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: openCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5E3C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
