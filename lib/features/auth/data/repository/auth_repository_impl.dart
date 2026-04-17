import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AppUser> login(String email, String password) async {
    final res = await remote.login(email, password);
    return UserModel.fromFirebase(res.user!);
  }

  @override
  Future<AppUser> register(String email, String password) async {
    final res = await remote.register(email, password);
    return UserModel.fromFirebase(res.user!);
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }
}