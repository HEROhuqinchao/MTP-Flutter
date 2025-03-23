import 'package:hive_ce/hive.dart';

class ChatMessage extends HiveObject {
  ChatMessage({required this.role, required this.content, this.isRead = true});

  String role;
  String content;
  bool? isRead;
}
