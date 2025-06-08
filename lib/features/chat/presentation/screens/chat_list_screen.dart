import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/chat/presentation/providers/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 16),
            const SizedBox(width: 2),
            Text(' ${user?.username} '),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Chat List'),
            const SizedBox(height: 8),
            const Divider(),

            Expanded(child: _Profiles()),
          ],
        ),
      ),
    );
  }
}

class _Profiles extends ConsumerWidget {
  const _Profiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final profiles =
        ref
            .watch(profilesProvider)
            .profiles
            .where((profile) => profile.id != user?.uid)
            .toList();
    return profiles.isEmpty
        ? const Center(child: Text('No profiles found'))
        : ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.push('/chat/${profiles[index].id}');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(profiles[index].username),
                  subtitle: const Text('Online'),
                  trailing: const Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 16,
                  ),
                ),
              ),
            );
          },
        );
  }
}
