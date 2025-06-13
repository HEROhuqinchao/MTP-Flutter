import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/role/domain/repositories/role_repository.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/chat/domain/repositories/llm_repository.dart';
import '../dependency_injection.dart';

// 仓库提供者 - 使用依赖注入获取仓库实例
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return getIt<ChatRepository>();
});

final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  return getIt<RoleRepository>();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return getIt<SettingsRepository>();
});

final llmRepositoryProvider = Provider<LlmRepository>((ref) {
  return getIt<LlmRepository>();
});
