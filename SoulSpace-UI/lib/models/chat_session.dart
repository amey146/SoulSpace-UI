import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 1)
class ChatSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.messages,
  });
}

@HiveType(typeId: 2)
class ChatMessage {
  @HiveField(0)
  String role;

  @HiveField(1)
  String content;

  ChatMessage({required this.role, required this.content});
}
