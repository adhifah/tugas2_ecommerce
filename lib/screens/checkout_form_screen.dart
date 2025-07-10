import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CheckoutFormScreen extends StatefulWidget {
  final List<Product> cart;
  final double total;
  final VoidCallback? onCheckoutComplete;

  const CheckoutFormScreen({
    Key? key,
    required this.cart,
    required this.total,
    this.onCheckoutComplete,
  }) : super(key: key);

  @override
  State<CheckoutFormScreen> createState() => _CheckoutFormScreenState();
}

class _CheckoutFormScreenState extends State<CheckoutFormScreen> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  String selectedPayment = 'Transfer Bank';
  String selectedShipping = 'JNE';

  void confirmOrder() async {
    final name = nameCtrl.text.trim();
    final address = addressCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data terlebih dahulu")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    widget.onCheckoutComplete?.call();

    // Tampilkan animasi sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/success.json', width: 150),
            const SizedBox(height: 16),
            const Text('Pembayaran Berhasil!'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pop(); // Tutup dialog
    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF8B5E3C),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCartSummary(),
          const SizedBox(height: 24),
          const Text("Informasi Pengiriman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInputField("Nama Lengkap", nameCtrl),
          const SizedBox(height: 12),
          _buildInputField("Alamat Pengiriman", addressCtrl, maxLines: 2),
          const SizedBox(height: 12),
          _buildInputField("Nomor Telepon", phoneCtrl, keyboardType: TextInputType.phone),
          const SizedBox(height: 24),
          const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedPayment,
            items: [
              'Transfer Bank',
              'e-Wallet (Dana, OVO, GoPay)',
              'COD (Bayar di Tempat)',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedPayment = val!),
            decoration: _dropdownDecoration(),
          ),
          const SizedBox(height: 16),
          const Text("Metode Pengiriman", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedShipping,
            items: [
              'JNE',
              'SiCepat',
              'AnterAja',
              'GoSend (Instan)',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedShipping = val!),
            decoration: _dropdownDecoration(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5E3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Konfirmasi Pembayaran (${_formatCurrency(widget.total)})'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    final Map<String, Map<String, dynamic>> grouped = {};
    for (var item in widget.cart) {
      final id = item.id.toString();
      if (grouped.containsKey(id)) {
        grouped[id]!['qty'] += 1;
      } else {
        grouped[id] = {'product': item, 'qty': 1};
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ringkasan Pesanan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...grouped.values.map((entry) {
            final product = entry['product'] as Product;
            final qty = entry['qty'] as int;
            final subtotal = product.price * qty;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("${product.name} x$qty", overflow: TextOverflow.ellipsis)),
                  Text(currencyFormatter.format(subtotal)),
                ],
              ),
            );
          }),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(currencyFormatter.format(widget.total), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(value);
  }
}
