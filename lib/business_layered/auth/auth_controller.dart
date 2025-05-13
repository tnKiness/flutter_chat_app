// lib/logic/auth/auth_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/data_layered/auth/firebase_auth_service.dart';

class AuthController {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<UserCredential?> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      return await _authService.signIn(email, password);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed.')),
      );
      return null;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required File imageFile,
    required BuildContext context,
  }) async {
    try {
      return await _authService.signUp(
        email: email,
        password: password,
        username: username,
        imageFile: imageFile,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed.')),
      );
      return;
    }
  }
}
