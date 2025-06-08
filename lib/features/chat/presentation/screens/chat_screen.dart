import 'package:epale_app/features/chat/presentation/providers/message_provider.dart';
import 'package:epale_app/features/chat/presentation/providers/messages_provider.dart';
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
    final messagesState = ref.watch(messagesProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:
            profileState.isLoading
                ? null
                : Text(profileState.profile?.username ?? 'Username'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child:
                messagesState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: messagesState.messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(messagesState.messages[index].content),
                        );
                      },
                    ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.grey[200],
            child: _ChatBox(profileId: profileId),
          ),
        ],
      ),
    );
  }
}

class _ChatBox extends ConsumerWidget {
  final String profileId;

  _ChatBox({required this.profileId});

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendMessage = ref.read(messageProvider.notifier).sendMessage;
    return SafeArea(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                onChanged: (value) {
                  ref.read(messageProvider.notifier).setMessage(value);
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send message',
                ),
                focusNode: focusNode,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                sendMessage(profileId);
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
