import 'dart:async';

import 'package:epale_app/features/chat/domain/datasources/message_datasource.dart';
import 'package:epale_app/features/chat/domain/entities/message.dart';
import 'package:epale_app/features/chat/infrastructure/errors/profile_errors.dart';
import 'package:epale_app/features/chat/infrastructure/mappers/message_mapper.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class MessageDataSourceImpl implements MessageDataSource {
  final supabase = Supabase.instance.client;
  @override
  Future<List<Message>> getMessages(String profileId, String userId) async {
    try {
      final userMessages = await supabase
          .from('messages')
          .select('*')
          .eq('from', userId)
          .eq('to', profileId)
          .order('created_at', ascending: true)
          .limit(100);

      final profileMessages = await supabase
          .from('messages')
          .select('*')
          .eq('from', profileId)
          .eq('to', userId)
          .order('created_at', ascending: true)
          .limit(100);

      return [...userMessages, ...profileMessages]
          .map(
            (message) => MessageMapper.remoteMessageToMessage(
              map: message,
              userId: userId,
            ),
          )
          .toList();
    } catch (e) {
      throw CustomError('Unable to get messages.');
    }
  }

  @override
  Future<Message> sendMessage(
    String profileId,
    String userId,
    String message,
  ) async {
    try {
      final newMessage =
          await supabase
              .from('messages')
              .insert({'from': userId, 'to': profileId, 'content': message})
              .select()
              .single();
      return MessageMapper.remoteMessageToMessage(
        map: newMessage,
        userId: userId,
      );
    } catch (e) {
      throw CustomError('Unable to send message.');
    }
  }

  @override
  RealtimeChannel onNewMessageInserted(String profileId, String userId) {
    List<String> ids = [profileId, userId]..sort();

    final channelName = 'messages_${ids[0]}_${ids[1]}';
    return supabase.channel(channelName);
  }
}
