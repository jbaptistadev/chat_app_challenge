import 'package:epale_app/features/chat/domain/entities/profile.dart';

class ProfileMapper {
  static Profile remoteProfileToProfile(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      avatarUrl: json['avatar_url'] ?? 'no-avatar-url',
      username: json['username'] ?? '',
    );
  }
}
