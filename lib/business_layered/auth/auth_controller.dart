// lib/logic/auth/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:chat_app/data_layered/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<UserCredential?> submitAuth({
    required String email,
    required String password,
    required bool isLogin,
    required BuildContext context,
  }) async {
    try {
      if (isLogin) {
        return await _authService.signIn(email, password);
      } else {
        return await _authService.signUp(email, password);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed.')),
      );
      return null;
    }
  }
}
