import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/di/dependency_injection.dart';
import 'package:mtp/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/features/role/domain/repositories/role_repository.dart';
import 'package:mtp/src/features/settings/domain/repositories/settings_repository.dart';

/// 仓库提供者
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return getIt<ChatRepository>();
});

final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  return getIt<RoleRepository>();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return getIt<SettingsRepository>();
});

final llmRepositoryProvider = Provider<LLMRepository>((ref) {
  return getIt<LLMRepository>();
});
