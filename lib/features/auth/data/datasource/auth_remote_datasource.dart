import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/network/firebase_service.dart';

class AuthRemoteDataSource {
  Future<UserCredential> login(String email, String password) {
    return AuthService.signIn(email: email, password: password);
  }

  Future<UserCredential> register(String email, String password) {
    return AuthService.signUp(email: email, password: password);
  }

  Future<void> logout() {
    return AuthService.signOut();
  }
}