import 'package:epale_app/features/chat/domain/entities/message.dart';

class MessageMapper {
  static Message remoteMessageToMessage({
    required Map<String, dynamic> map,
    required String userId,
  }) {
    return Message(
      id: map['id'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      isMine: userId == map['from'],
    );
  }
}
