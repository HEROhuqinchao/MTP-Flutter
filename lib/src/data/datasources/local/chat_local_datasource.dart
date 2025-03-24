import 'package:hive_ce/hive.dart';

import '../../models/chat/message.dart';
import '../../models/chat/session.dart';

class ChatLocalDatasource {
  static const String _boxName = 'sessions';
  late Box<Session> sessionsBox;
  bool _isInitialized = false;

  // 初始化数据库
  Future<void> initialize() async {
    if (!_isInitialized) {
      sessionsBox = await Hive.openBox<Session>(_boxName);
      _isInitialized = true;
    }
  }

  // 确保已初始化的辅助方法
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // 添加会话
  Future<void> addSession(Session session) async {
    await _ensureInitialized();
    session.createdAt ??= DateTime.now();
    session.updatedAt ??= DateTime.now();
    await sessionsBox.add(session);
  }

  // 获取所有会话
  Future<List<Session>> getAllSessions() async {
    await _ensureInitialized();
    return sessionsBox.values.toList();
  }

  // 根据ID获取特定会话
  Future<Session?> getSessionById(String id) async {
    await _ensureInitialized();
    for (int i = 0; i < sessionsBox.length; i++) {
      final session = sessionsBox.getAt(i);
      if (session?.key == id) {
        return session;
      }
    }
    return null;
  }

  // 根据角色ID获取相关会话
  Future<List<Session>> getSessionsByRoleId(String roleId) async {
    await _ensureInitialized();
    return sessionsBox.values
        .where((session) => session.roleId == roleId)
        .toList();
  }

  // 更新会话
  Future<void> updateSession(Session session) async {
    await _ensureInitialized();
    if (session.key == null) {
      throw Exception('无法更新没有key的会话');
    }

    session.updatedAt = DateTime.now();

    for (int i = 0; i < sessionsBox.length; i++) {
      final existingSession = sessionsBox.getAt(i);
      if (existingSession?.key == session.key) {
        await sessionsBox.putAt(i, session);
        return;
      }
    }

    throw Exception('未找到要更新的会话');
  }

  // 向会话添加消息
  Future<void> addMessageToSession(
    String sessionId,
    ChatMessage message,
  ) async {
    await _ensureInitialized();
    final session = await getSessionById(sessionId);
    if (session == null) {
      throw Exception('未找到指定的会话');
    }

    session.addMessage(message);
    await updateSession(session);
  }

  // 获取会话中的所有消息
  Future<List<ChatMessage>> getMessagesFromSession(String sessionId) async {
    await _ensureInitialized();
    final session = await getSessionById(sessionId);
    if (session == null) {
      throw Exception('未找到指定的会话');
    }

    return session.messages;
  }

  // 删除会话
  Future<void> deleteSession(String id) async {
    await _ensureInitialized();
    for (int i = 0; i < sessionsBox.length; i++) {
      final session = sessionsBox.getAt(i);
      if (session?.key == id) {
        await sessionsBox.deleteAt(i);
        return;
      }
    }
  }

  // 清空所有会话
  Future<void> clearAllSessions() async {
    await _ensureInitialized();
    await sessionsBox.clear();
  }

  // 清空所有会话中的消息（保留会话本身）
  Future<void> clearAllMessages() async {
    await _ensureInitialized();

    // 获取所有会话
    final sessions = sessionsBox.values.toList();

    // 遍历每个会话，清空消息
    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      session.messages = []; // 清空消息列表
      session.updatedAt = DateTime.now(); // 更新时间戳

      // 更新会话
      await sessionsBox.putAt(i, session);
    }
  }

  // 搜索会话
  Future<List<Session>> searchSessions(String query) async {
    await _ensureInitialized();
    return sessionsBox.values
        .where(
          (session) =>
              session.title.toLowerCase().contains(query.toLowerCase()) ||
              session.messages.any(
                (msg) =>
                    msg.content.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }
}
