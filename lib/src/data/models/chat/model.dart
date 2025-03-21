import 'package:hive_ce/hive.dart';

class ChatModel extends HiveObject {
  ChatModel({
    this.key,
    required this.name,
    required this.endpoint,
    required this.apiKey,
    required this.temparture,
    required this.isSelected,
  });

  @override
  String? key;
  String name;
  String endpoint;
  String apiKey;
  double temparture;
  bool isSelected;
}
