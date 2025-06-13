import 'package:mtp/src/shared/data/datasources/local/app_database.dart';

class SessionWithDetails {
  final Session session;
  final List<String> roleIds;
  final ChatMessage? lastMessage;

  SessionWithDetails(this.session, this.roleIds, this.lastMessage);
}
