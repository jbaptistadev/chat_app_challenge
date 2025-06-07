import 'package:epale_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:epale_app/features/auth/domain/entities/user.dart';
import 'package:epale_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:epale_app/features/auth/infrastructure/datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? dataSource})
    : datasource = dataSource ?? AuthDatasourceImpl();
  @override
  Future<UserEntity> signIn(String email, String password) {
    return datasource.signIn(email, password);
  }

  @override
  Future<UserEntity> signUp(String email, String password, String displayName) {
    return datasource.signUp(email, password, displayName);
  }

  @override
  UserEntity checkAuthStatus() {
    return datasource.checkAuthStatus();
  }

  @override
  Future<void> signOut() {
    return datasource.signOut();
  }
}
