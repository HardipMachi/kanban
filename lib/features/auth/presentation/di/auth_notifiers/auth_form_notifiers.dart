import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthFormNotifier extends StateNotifier<int> {
  AuthFormNotifier() : super(0); // use int as dummy state

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validate({bool isRegister = false}) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (isRegister && name.isEmpty) return false;
    if (email.isEmpty || password.isEmpty) return false;
    return true;
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    state++; // trigger rebuild
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
