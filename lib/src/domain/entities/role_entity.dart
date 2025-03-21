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
}
