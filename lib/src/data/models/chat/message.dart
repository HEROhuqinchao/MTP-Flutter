import 'package:hive_ce/hive.dart';

class ChatMessage extends HiveObject {
  ChatMessage({required this.role, required this.content, this.isRead = true});

  String role;
  String content;
  bool? isRead;
}

// import 'package:drift/drift.dart';
//
// class ChatMessage extends Table {
//   late final role = text();
//   late final content = text();
//   late final isRead = boolean().nullable();
// }
