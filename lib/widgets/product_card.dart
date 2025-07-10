import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAdd;

  ProductCard({required this.product, required this.onAdd});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedScale(
        scale: _isTapped ? 0.97 : 1.0,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Card(
          margin: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.network(widget.product.image, width: 80, height: 80, fit: BoxFit.cover),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Rp ${widget.product.price}',
                          style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: widget.onAdd, child: Icon(Icons.add))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
