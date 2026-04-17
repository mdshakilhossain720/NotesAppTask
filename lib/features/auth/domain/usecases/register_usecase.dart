import '../entities/user.dart';
import '../repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AppUser> call(String email, String password) {
    return repository.register(email, password);
  }
}