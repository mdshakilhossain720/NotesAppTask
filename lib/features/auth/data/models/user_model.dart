import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user.dart';

class UserModel extends AppUser {
  UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
    );
  }
}