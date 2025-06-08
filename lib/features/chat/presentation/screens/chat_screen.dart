import 'dart:io';

import 'package:epale_app/features/chat/presentation/providers/message_provider.dart';
import 'package:epale_app/features/chat/presentation/providers/messages_provider.dart';
import 'package:epale_app/features/chat/presentation/providers/profile_provider.dart';
import 'package:epale_app/features/chat/presentation/widgets/bubble_chat.dart';
import 'package:flutter/cupertino.dart';
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

class _Chat extends ConsumerStatefulWidget {
  final String profileId;

  const _Chat({required this.profileId});

  @override
  ConsumerState<_Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<_Chat> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant _Chat oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider(widget.profileId));
    final messagesState = ref.watch(messagesProvider(widget.profileId));

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

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
                      controller: _scrollController,
                      itemCount: messagesState.messages.length,
                      itemBuilder: (context, index) {
                        final message = messagesState.messages[index];
                        return BubbleChat(
                          content: message.content,
                          isMine: message.isMine,
                          createdAt: message.createdAt,
                        );
                      },
                    ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.grey[200],
            child: _ChatBox(profileId: widget.profileId),
          ),
        ],
      ),
    );
  }
}

class _ChatBox extends ConsumerStatefulWidget {
  final String profileId;

  _ChatBox({required this.profileId});

  final focusNode = FocusNode();

  @override
  ConsumerState<_ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends ConsumerState<_ChatBox> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sendMessage = ref.read(messageProvider.notifier).sendMessage;
    return SafeArea(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: textController,
                onSubmitted: (value) {
                  if (value.isEmpty) return;
                  sendMessage(widget.profileId);
                  textController.clear();
                  widget.focusNode.requestFocus();
                },
                onChanged: (value) {
                  ref.read(messageProvider.notifier).setMessage(value);
                  textController.text = value;
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send message',
                ),
                focusNode: widget.focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child:
                  !Platform.isIOS
                      ? CupertinoButton(
                        onPressed: () {
                          if (textController.text.isEmpty) return;
                          sendMessage(widget.profileId);
                          textController.clear();
                          widget.focusNode.requestFocus();
                        },
                        child: const Text('send'),
                      )
                      : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (textController.text.isEmpty) return;
                              sendMessage(widget.profileId);
                              textController.clear();
                              widget.focusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
