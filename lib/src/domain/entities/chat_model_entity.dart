class ChatModelEntity {
  final String? id;
  final String name;
  final String endpoint;
  final String apiKey;
  final double temparture;
  final bool isSelected;

  ChatModelEntity({
    this.id,
    required this.name,
    required this.endpoint,
    required this.apiKey,
    required this.temparture,
    required this.isSelected,
  });
}
