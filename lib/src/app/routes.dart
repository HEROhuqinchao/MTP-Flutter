import 'package:go_router/go_router.dart';
import 'package:mtp/src/presentation/pages/chat_screen/widgets/conversation_list.dart';
import 'package:mtp/src/presentation/pages/chat_screen/widgets/conversation_view.dart';
import 'package:mtp/src/presentation/pages/settings_screen/settings_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => ConversationList()),
    GoRoute(path: '/chat', builder: (context, state) => ConversationView()),
    GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
  ],
);
