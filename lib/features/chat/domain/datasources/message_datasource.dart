import 'package:epale_app/features/chat/domain/entities/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MessageDataSource {
  Future<List<Message>> getMessages(String profileId, String userId);
  Future<void> sendMessage(String profileId, String userId, String message);
  RealtimeChannel onNewMessageInserted(String profileId, String userId);
}
