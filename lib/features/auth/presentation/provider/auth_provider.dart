import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasource/auth_remote_datasource.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// DataSource
final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(),
);

/// Repository
final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);

/// UseCases
final loginUseCaseProvider = Provider(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider(
  (ref) => RegisterUseCase(ref.read(authRepositoryProvider)),
);

/// Controller
class AuthController extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthController(this.loginUseCase, this.registerUseCase)
      : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await loginUseCase(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    try {
      await registerUseCase(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(
    ref.read(loginUseCaseProvider),
    ref.read(registerUseCaseProvider),
  ),
);