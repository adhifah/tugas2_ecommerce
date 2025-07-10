import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart'; // pastikan file ini sudah ada

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final userCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> register() async {
    final fullName = nameCtrl.text.trim();
    final username = userCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();

    if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    // 🔐 Register ke Firebase Auth
    final auth = AuthService();
    final firebaseUser = await auth.register(email, password);

    if (firebaseUser == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi gagal")),
      );
      return;
    }

    // 🌐 Simpan profil user ke db.json
    final url = Uri.parse('http://localhost:3000/users');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'id': firebaseUser.uid,
        'fullName': fullName,
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    userCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/panshop_logo.png',
                height: 130,
              ),
              const SizedBox(height: 32),

              _buildInputField(controller: nameCtrl, hint: "Full Name", icon: Icons.person),
              const SizedBox(height: 16),

              _buildInputField(controller: userCtrl, hint: "Username", icon: Icons.account_circle),
              const SizedBox(height: 16),

              _buildInputField(controller: emailCtrl, hint: "Email", icon: Icons.email),
              const SizedBox(height: 16),

              _buildInputField(
                controller: passCtrl,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 28),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5E3C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Login",
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
