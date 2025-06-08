import 'package:epale_app/features/chat/domain/entities/profile.dart';
import 'package:epale_app/features/chat/domain/repositories/profile_repository.dart';
import 'package:epale_app/features/chat/infrastructure/respositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilesProvider = StateNotifierProvider<ProfilesNotifier, ProfilesState>(
  (ref) {
    final profileRepository = ProfileRepositoryImpl();

    return ProfilesNotifier(profileRepository: profileRepository);
  },
);

class ProfilesNotifier extends StateNotifier<ProfilesState> {
  final ProfileRepository profileRepository;

  ProfilesNotifier({required this.profileRepository}) : super(ProfilesState()) {
    getProfiles();
  }

  Future<void> getProfiles() async {
    try {
      state = state.copyWith(isLoading: true);
      final profiles = await profileRepository.getProfiles();
      state = state.copyWith(isLoading: false, profiles: profiles);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

class ProfilesState {
  bool isLoading;
  List<Profile> profiles;
  ProfilesState({this.isLoading = false, this.profiles = const []});

  ProfilesState copyWith({bool? isLoading, List<Profile>? profiles}) {
    return ProfilesState(
      isLoading: isLoading ?? this.isLoading,
      profiles: profiles ?? this.profiles,
    );
  }
}
