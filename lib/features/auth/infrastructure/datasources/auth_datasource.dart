import 'package:epale_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:epale_app/features/auth/domain/entities/user.dart';
import 'package:epale_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:epale_app/features/auth/infrastructure/mappers/user_mapper.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final supabase = Supabase.instance.client;
  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw CustomError('Sign in failed: No user returned');
      }

      return UserMapper.remoteUserToUserEntity(user.toJson());
    } on AuthException catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError('Sign in failed: $e');
    }
  }

  @override
  Future<UserEntity> signUp(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      final user = response.user;
      if (user == null) {
        throw CustomError('Sign up failed: No user returned');
      }
      return UserMapper.remoteUserToUserEntity(user.toJson());
    } on AuthException catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError('Sign up failed: $e');
    }
  }

  @override
  UserEntity checkAuthStatus() {
    try {
      final response = supabase.auth.currentSession?.user;

      if (response == null) {
        throw CustomError('User not found');
      }

      return UserMapper.remoteUserToUserEntity(response.toJson());
    } on AuthException catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError('Check auth status failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw CustomError(e.message);
    } catch (e) {
      throw CustomError('Sign out failed: $e');
    }
  }
}
