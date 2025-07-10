import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? currentUser;
  String alamat = "";
  String fullName = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    loadUserProfile();
    loadAlamat();
  }

  void loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      setState(() {
        fullName = userMap['fullName'] ?? "";
        username = userMap['username'] ?? "";
      });
    }
  }

  void loadAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('alamat') ?? "";
    setState(() {
      alamat = savedAddress;
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  void editAlamat() async {
    final controller = TextEditingController(text: alamat);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Alamat"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Masukkan alamat lengkap"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('alamat', controller.text);
              setState(() {
                alamat = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDF8F3),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F3),
      appBar: AppBar(
        title: const Text("Akun Saya"),
        backgroundColor: const Color(0xFF8B5E3C),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.brown.shade200,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('@$username', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informasi Akun", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Nama Lengkap"),
                      Flexible(child: Text(fullName)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Username"),
                      Flexible(child: Text(username)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Alamat"),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                alamat.isEmpty ? "Belum diisi" : alamat,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: editAlamat,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: const Text("Keluar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
