import 'package:epale_app/features/chat/infrastructure/mappers/profile_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:epale_app/features/chat/domain/datasources/profile_datasource.dart';
import 'package:epale_app/features/chat/domain/entities/profile.dart';
import 'package:epale_app/features/chat/infrastructure/errors/profile_errors.dart';

class ProfileDataSourceImpl implements ProfileDatasource {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<Profile> getProfile(String id) async {
    try {
      final response = await supabase.from('profiles').select('*').eq('id', id);

      final List<dynamic> data = response;
      final profile =
          data
              .map((profile) => ProfileMapper.remoteProfileToProfile(profile))
              .toList();

      return profile.first;
    } catch (e) {
      throw CustomError('Unable to get profile.');
    }
  }

  @override
  Future<void> updateProfile(Profile profile) {
    throw UnimplementedError();
  }

  @override
  Future<List<Profile>> getProfiles() async {
    try {
      final response = await supabase.from('profiles').select('*');
      final List<dynamic> data = response;
      final profiles =
          data
              .map((profile) => ProfileMapper.remoteProfileToProfile(profile))
              .toList();

      return profiles;
    } catch (e) {
      throw CustomError('Unable to get profiles.');
    }
  }
}
