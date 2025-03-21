import 'package:hive_ce/hive.dart';

class Role extends HiveObject {
  Role({
    this.key,
    required this.name,
    required this.avatars,
    required this.prompt,
    required this.lastMessage,
  });

  @override
  String? key;
  String name;
  List<String> avatars;
  String prompt;
  String lastMessage;
}
