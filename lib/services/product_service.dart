import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Ganti localhost ke IP address laptop kalau pakai HP/emulator
  final String baseUrl = 'http://localhost:3000'; // Ganti xx sesuai IP laptopmu

  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat produk (${res.statusCode})");
    }
  }
}
