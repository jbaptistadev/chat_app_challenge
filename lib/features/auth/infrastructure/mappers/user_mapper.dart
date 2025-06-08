import 'package:epale_app/features/auth/domain/entities/user.dart';

class UserMapper {
  static UserEntity remoteUserToUserEntity(Map<String, dynamic> json) {
    final userMetadata = json['user_metadata'];

    return UserEntity(
      uid: json['id'] ?? '',
      email: json['email'] ?? '',
      username: userMetadata['username'] ?? '',
    );
  }
}
