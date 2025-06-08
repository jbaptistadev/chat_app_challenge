import 'package:epale_app/features/chat/domain/entities/profile.dart';
import 'package:epale_app/features/chat/domain/repositories/profile_repository.dart';
import 'package:epale_app/features/chat/infrastructure/errors/profile_errors.dart';
import 'package:epale_app/features/chat/presentation/providers/profile_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = StateNotifierProvider.autoDispose
    .family<ProfileNtifier, ProfileState, String>((ref, profileId) {
      final profileRepository = ref.read(profileRepositoryProvider);

      return ProfileNtifier(
        profileId: profileId,
        profileRepository: profileRepository,
      );
    });

class ProfileNtifier extends StateNotifier<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileNtifier({required String profileId, required this.profileRepository})
    : super(ProfileState(profileId: profileId)) {
    getProfile();
  }

  Future<Profile> getProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final profile = await profileRepository.getProfile(state.profileId);
      state = state.copyWith(profile: profile, isLoading: false);
      return profile;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw CustomError('Unable to get profile.');
    }
  }
}

class ProfileState {
  final String profileId;
  final Profile? profile;
  final bool isLoading;

  ProfileState({required this.profileId, this.profile, this.isLoading = false});

  ProfileState copyWith({
    String? profileId,
    Profile? profile,
    bool? isLoading,
  }) {
    return ProfileState(
      profileId: profileId ?? this.profileId,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
