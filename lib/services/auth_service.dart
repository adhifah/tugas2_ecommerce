import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil data user dari db.json berdasarkan email
      final dbResponse = await http.get(Uri.parse('http://localhost:3000/users'));
      if (dbResponse.statusCode == 200) {
        final List users = jsonDecode(dbResponse.body);
        final foundUser = users.firstWhere(
              (u) => u['email'] == email,
          orElse: () => null,
        );

        if (foundUser != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_profile', jsonEncode(foundUser));
        }
      }

      return result.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
