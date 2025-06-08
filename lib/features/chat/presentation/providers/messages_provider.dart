import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/chat/domain/entities/message.dart';
import 'package:epale_app/features/chat/domain/repositories/message_repository.dart';
import 'package:epale_app/features/chat/infrastructure/mappers/message_mapper.dart';
import 'package:epale_app/features/chat/infrastructure/respositories/message_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messagesProvider = StateNotifierProvider.autoDispose
    .family<MessagesNotifier, MessagesState, String>((ref, profileId) {
      final messageRepository = MessageRepositoryImpl();
      final userId = ref.watch(authProvider).user!.uid;
      return MessagesNotifier(
        messageRepository: messageRepository,
        profileId: profileId,
        userId: userId,
      );
    });

class MessagesNotifier extends StateNotifier<MessagesState> {
  final MessageRepository messageRepository;
  final String profileId;
  final String userId;
  late RealtimeChannel _channel;
  MessagesNotifier({
    required this.messageRepository,
    required this.profileId,
    required this.userId,
  }) : super(MessagesState()) {
    getMessages();
    onNewMessageInserted();
  }

  Future<void> onNewMessageInserted() async {
    _channel =
        messageRepository
            .onNewMessageInserted(profileId, userId)
            .onPostgresChanges(
              schema: 'public',
              table: 'messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'from',
                value: userId,
              ),
              event: PostgresChangeEvent.all,
              callback: (payload) {
                state = state.copyWith(
                  messages: [
                    ...state.messages,
                    MessageMapper.remoteMessageToMessage(
                      map: payload.newRecord,
                      userId: userId,
                    ),
                  ],
                );
              },
            )
            .onPostgresChanges(
              schema: 'public',
              table: 'messages',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'to',
                value: userId,
              ),
              event: PostgresChangeEvent.all,
              callback: (payload) {
                state = state.copyWith(
                  messages: [
                    ...state.messages,
                    MessageMapper.remoteMessageToMessage(
                      map: payload.newRecord,
                      userId: userId,
                    ),
                  ],
                );
              },
            )
            .subscribe();
  }

  Future<void> channelUnsubscribe() async {
    _channel.unsubscribe();
  }

  Future<void> getMessages() async {
    state = state.copyWith(isLoading: true);

    try {
      final messages = await messageRepository.getMessages(profileId, userId);
      state = state.copyWith(isLoading: false, messages: messages);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    channelUnsubscribe();
    super.dispose();
  }
}

class MessagesState {
  final List<Message> messages;
  final bool isLoading;

  MessagesState({this.messages = const [], this.isLoading = false});

  MessagesState copyWith({List<Message>? messages, bool? isLoading}) {
    return MessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
