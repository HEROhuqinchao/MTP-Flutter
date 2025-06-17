import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mtp/src/features/chat/data/datasources/local/dao/sessions_dao.dart';
import 'package:mtp/src/features/role/data/datasources/local/dao/roles_dao.dart';
import 'package:mtp/src/features/settings/data/datasources/local/dao/settings_dao.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/utils/logger.dart';

// Data Sources
import '../features/role/data/datasources/remote/role_remote_datasource.dart';
import '../features/chat/data/datasources/remote/open_ai_remote_datasource.dart';
import '../features/chat/data/datasources/remote/azure_open_ai_remote_datasource.dart';

// Repositories
import '../features/chat/data/repositories/llm_repository_impl.dart';
import '../features/role/data/repositories/role_repository_impl.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';

// Domain
import '../features/chat/domain/repositories/llm_repository.dart';
import '../features/role/domain/repositories/role_repository.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/chat/domain/usecases/generate_completion.dart';
import '../features/chat/domain/usecases/generate_completion_stream.dart';

final getIt = GetIt.instance;
final Logger _logger = Logger('Network');

Future<void> initDependencies() async {
  // 初始化日志
  _initLogging();

  // 外部依赖
  _registerExternalDependencies();

  final db = AppDatabase();

  // 数据源
  _registerDataSources(db);
  // await _initializeDataSources();

  // 仓库
  _registerRepositories();
  await _initializeRepositories();

  // 用例
  _registerUseCases();
}

// 添加初始化数据源的函数
// Future<void> _initializeDataSources(AppDatabase db) async {
// }

Future<void> _initializeRepositories() async {
  await getIt<RoleRepository>().initialize();
}

// 在应用初始化时
Future<void> ensureDefaultSessions() async {
  try {
    final roleRepository = getIt<RoleRepository>();
    final chatRepository = getIt<SessionsDao>();

    // 获取所有角色
    final roles = await roleRepository.getAllRoles();
    localLogger.config('获取到 ${roles.length} 个角色');
    final rolesData = roles.map((role) => (role.id, role.name)).toList();

    // 为每个角色检查并创建默认会话
    await chatRepository.ensureRoleSessionsExist(rolesData);
  } catch (e) {
    localLogger.shout('确保默认会话时出错: $e');
  }

  localLogger.config('确保默认会话完成');
}

void _registerExternalDependencies() {
  final dio = Dio();

  // 配置Dio
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 600);
  dio.options.sendTimeout = const Duration(seconds: 30);

  // 添加拦截器用于日志等
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) {
        _logger.fine('DIO: $log');
      },
    ),
  );

  getIt.registerSingleton<Dio>(dio);
}

void _registerDataSources(AppDatabase db) {
  // 本地数据源
  getIt.registerLazySingleton(() => SessionsDao(db));
  getIt.registerLazySingleton(() => RolesDao(db));
  getIt.registerLazySingleton(() => SettingsDao(db));

  // 远程数据源
  getIt.registerFactory<RoleRemoteDatasource>(
    () => RoleRemoteDatasource(dio: getIt<Dio>()),
  );

  getIt.registerFactory<OpenAiRemoteDatasource>(
    () => OpenAiRemoteDatasource(dio: getIt<Dio>()),
  );

  getIt.registerFactory<AzureOpenAiRemoteDatasource>(
    () => AzureOpenAiRemoteDatasource(dio: getIt<Dio>()),
  );
}

void _registerRepositories() {
  // LLM仓库
  getIt.registerFactory<LLMRepository>(
    () => LlmRepositoryImpl(dio: getIt<Dio>()),
  );

  // 角色仓库
  getIt.registerSingleton<RoleRepository>(
    RoleRepositoryImpl(getIt<RolesDao>(), getIt<RoleRemoteDatasource>()),
  );

  // 聊天仓库
  getIt.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(getIt<SessionsDao>()),
  );

  // 设置仓库
  getIt.registerSingleton<SettingsRepository>(
    SettingsRepositoryImpl(getIt<SettingsDao>()),
  );
}

void _registerUseCases() {
  // 文本生成相关用例
  getIt.registerFactory<GenerateCompletion>(
    () => GenerateCompletion(getIt<LLMRepository>()),
  );

  getIt.registerFactory<GenerateCompletionStream>(
    () => GenerateCompletionStream(getIt<LLMRepository>()),
  );
}

// 初始化日志配置
void _initLogging() {
  Logger.root.level = Level.ALL; // 默认记录所有级别的日志
  Logger.root.onRecord.listen((record) {
    // 根据记录级别使用不同的输出格式
    final emoji = _getLogLevelEmoji(record.level);
    print('${record.time} $emoji ${record.level.name}: ${record.message}');

    // 如果有异常，也将异常信息记录下来
    if (record.error != null) {
      print('ERROR: ${record.error}');
      if (record.stackTrace != null) {
        print('STACKTRACE: ${record.stackTrace}');
      }
    }
  });
}

// 根据日志级别返回对应的表情符号，让日志更直观
String _getLogLevelEmoji(Level level) {
  if (level == Level.FINEST) return '🔍';
  if (level == Level.FINER) return '🔎';
  if (level == Level.FINE) return '🔬';
  if (level == Level.CONFIG) return '⚙️';
  if (level == Level.INFO) return '💡';
  if (level == Level.WARNING) return '⚠️';
  if (level == Level.SEVERE) return '🔥';
  if (level == Level.SHOUT) return '📢';
  return '📝';
}
