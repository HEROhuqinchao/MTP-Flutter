class ChatModelEntity {
  final String? id;
  final String name;
  final String endpoint;
  final double temparture;
  final String apiKey;
  final bool isSelected;

  ChatModelEntity({
    this.id,
    required this.name,
    required this.endpoint,
    required this.temparture,
    required this.apiKey,
    required this.isSelected,
  });

  ChatModelEntity copyWith({
    String? name,
    String? endpoint,
    String? apiKey,
    double? temparture,
    bool? isSelected,
  }) {
    return ChatModelEntity(
      id: this.id,
      name: name ?? this.name,
      endpoint: endpoint ?? this.endpoint,
      temparture: temparture ?? this.temparture,
      apiKey: apiKey ?? this.apiKey,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
