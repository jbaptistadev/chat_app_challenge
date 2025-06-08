import 'package:epale_app/features/chat/domain/datasources/profile_datasource.dart';
import 'package:epale_app/features/chat/domain/entities/profile.dart';
import 'package:epale_app/features/chat/domain/repositories/profile_repository.dart';
import 'package:epale_app/features/chat/infrastructure/datasources/profile_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl({ProfileDatasource? dataSource})
    : datasource = dataSource ?? ProfileDataSourceImpl();

  @override
  Future<Profile> getProfile(String id) {
    return datasource.getProfile(id);
  }

  @override
  Future<void> updateProfile(Profile profile) {
    return datasource.updateProfile(profile);
  }

  @override
  Future<List<Profile>> getProfiles() {
    return datasource.getProfiles();
  }
}
