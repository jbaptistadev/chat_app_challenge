import 'package:epale_app/features/chat/domain/entities/profile.dart';

abstract class ProfileDatasource {
  Future<Profile> getProfile(String id);
  Future<void> updateProfile(Profile profile);
  Future<List<Profile>> getProfiles();
}
