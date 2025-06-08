class Profile {
  final String id;

  final String username;
  final String? avatarUrl;

  Profile({required this.id, required this.username, this.avatarUrl = ''});
}
