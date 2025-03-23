class RoleEntity {
  final String? id;
  final String name;
  final List<String> avatars;
  final String prompt;
  final String lastMessage;

  RoleEntity({
    this.id,
    required this.name,
    required this.avatars,
    required this.prompt,
    required this.lastMessage,
  });

  RoleEntity copyWith({
    String? id,
    String? name,
    List<String>? avatars,
    String? prompt,
    String? lastMessage,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      avatars: avatars ?? this.avatars,
      prompt: prompt ?? this.prompt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
