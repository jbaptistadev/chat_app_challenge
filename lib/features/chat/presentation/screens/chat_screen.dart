import 'package:epale_app/features/chat/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatelessWidget {
  final String profileId;

  const ChatScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return _Chat(profileId: profileId);
  }
}

class _Chat extends ConsumerWidget {
  final String profileId;

  const _Chat({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider(profileId));

    return Scaffold(
      appBar:
          profileState.isLoading
              ? null
              : AppBar(
                centerTitle: false,
                title: Text(profileState.profile?.username ?? 'Username'),
                leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
      body: Column(
        children: [
          Flexible(child: Column(children: [const Text('Chat')])),
          const Divider(height: 1),
          Container(color: Colors.grey[200], child: _ChatBox()),
        ],
      ),
    );
  }
}

class _ChatBox extends StatelessWidget {
  _ChatBox();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send message',
                ),
                focusNode: focusNode,
              ),
            ),

            ElevatedButton(onPressed: () {}, child: const Text('Send')),
          ],
        ),
      ),
    );
  }
}
