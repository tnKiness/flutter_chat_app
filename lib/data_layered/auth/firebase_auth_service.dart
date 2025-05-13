// lib/data/auth/firebase_auth_service.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'YOUR_CLOUD_NAME',
    'YOUR_UPLOAD_PRESET',
    cache: false,
  );

  Future<UserCredential> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required File imageFile,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final cloudinaryResponse = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        imageFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      'image_url': cloudinaryResponse.secureUrl,
    });
  }
}
