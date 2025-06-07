import 'package:epale_app/features/auth/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password, String displayName);
  UserEntity checkAuthStatus();
  Future<void> signOut();
}
