import 'package:hive_ce/hive.dart';

class ChatMessage extends HiveObject {
  ChatMessage({required this.role, required this.content});

  String role;
  String content;
}
