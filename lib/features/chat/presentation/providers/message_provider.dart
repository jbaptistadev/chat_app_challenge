import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/chat/domain/repositories/message_repository.dart';
import 'package:epale_app/features/chat/infrastructure/errors/profile_errors.dart';
import 'package:epale_app/features/chat/infrastructure/respositories/message_repository_impl.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/MessageText.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StateNotifierProvider<MessageNotifier, MessageState>((
  ref,
) {
  final messageRepository = MessageRepositoryImpl();
  final userId = ref.watch(authProvider).user!.uid;
  return MessageNotifier(messageRepository: messageRepository, userId: userId);
});

class MessageNotifier extends StateNotifier<MessageState> {
  final MessageRepository messageRepository;
  final String userId;
  MessageNotifier({required this.messageRepository, required this.userId})
    : super(MessageState());

  void setMessage(String message) {
    state = state.copyWith(message: MessageText.dirty(message));
  }

  Future<void> sendMessage(String profileId) async {
    state = state.copyWith(isLoading: true);

    try {
      await messageRepository.sendMessage(
        profileId,
        userId,
        state.message.value,
      );
      state = state.copyWith(
        isLoading: false,
        message: const MessageText.pure(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw CustomError('Unable to send message.');
    }
  }
}

class MessageState {
  final bool isLoading;
  final MessageText message;
  final String errorMessage;

  MessageState({
    this.isLoading = false,
    this.errorMessage = '',
    this.message = const MessageText.pure(),
  });

  MessageState copyWith({
    bool? isLoading,
    String? errorMessage,
    MessageText? message,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}
