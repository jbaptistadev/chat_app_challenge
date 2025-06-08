import 'package:epale_app/features/chat/domain/entities/message.dart';
import 'package:epale_app/features/chat/domain/datasources/message_datasource.dart';
import 'package:epale_app/features/chat/domain/repositories/message_repository.dart';
import 'package:epale_app/features/chat/infrastructure/datasources/message_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource datasource;

  MessageRepositoryImpl({MessageDataSource? dataSource})
    : datasource = dataSource ?? MessageDataSourceImpl();

  @override
  Future<List<Message>> getMessages(String profileId, String userId) {
    return datasource.getMessages(profileId, userId);
  }

  @override
  Future<void> sendMessage(String profileId, String userId, String message) {
    return datasource.sendMessage(profileId, userId, message);
  }

  @override
  RealtimeChannel onNewMessageInserted(String profileId, String userId) {
    return datasource.onNewMessageInserted(profileId, userId);
  }
}
