import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final AuthService _auth = AuthService();

  void login(BuildContext context) async {
    final user = await _auth.login(userCtrl.text, passCtrl.text);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);
      prefs.setString('user', jsonEncode({
        'uid': user.uid,
        'email': user.email,
      }));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3), // Creamy soft background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
                child: Image.asset(
                  'assets/panshop_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Welcome to Panshop",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A3E36),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade100,
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: userCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.person_outline),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade100,
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5E3C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Belum punya akun? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Daftar",
                        style: TextStyle(
                          color: Color(0xFF8B5E3C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
