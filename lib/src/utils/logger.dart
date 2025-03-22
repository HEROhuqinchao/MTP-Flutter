import 'package:logging/logging.dart';

/// 应用程序日志工具类
class AppLogger {
  static final Map<String, Logger> _loggers = {};

  /// 获取指定名称的日志记录器
  static Logger getLogger(String name) {
    if (!_loggers.containsKey(name)) {
      _loggers[name] = Logger(name);
    }
    return _loggers[name]!;
  }

  /// 初始化日志系统
  static void init({Level level = Level.INFO}) {
    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      final emoji = _getLogLevelEmoji(record.level);
      final loggerName =
          record.loggerName.isNotEmpty ? '[${record.loggerName}]' : '';
      print(
        '${record.time} $emoji ${record.level.name} $loggerName: ${record.message}',
      );

      if (record.error != null) {
        print('ERROR: ${record.error}');
        if (record.stackTrace != null) {
          print('STACKTRACE: ${record.stackTrace}');
        }
      }
    });
  }

  /// 根据日志级别返回对应的表情符号
  static String _getLogLevelEmoji(Level level) {
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
}

final localLogger = Logger('LOCAL');
final remoteLogger = Logger('NETWORK');
