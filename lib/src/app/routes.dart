import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mtp/src/core/layouts/desktop_layout.dart';
import 'package:mtp/src/core/layouts/mobile_landscape_layout.dart';
import 'package:mtp/src/core/layouts/mobile_layout.dart';
import 'package:mtp/src/core/layouts/responsive_layout.dart';
import 'package:mtp/src/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:mtp/src/features/chat/presentation/widgets/chat_list.dart';
import 'package:mtp/src/features/settings/presentation/pages/settings_screen.dart';
import 'package:mtp/src/features/chat/presentation/pages/chat_empty_screen.dart';

final router = GoRouter(initialLocation: '/chat', routes: [_routes()]);

ShellRoute _routes() {
  return ShellRoute(
    builder: (context, state, child) {
      final isMobile = Platform.isAndroid || Platform.isIOS;

      if (isMobile) {
        return ResponsiveLayout(
          mobileLayout: MobileLayout(child: child),
          mobileLandscapeLayout: MobileLandscapeLayout(child: child),
        );
      } else {
        final isChatPage = state.fullPath?.contains('/chat');

        return DesktopLayout(showChatList: isChatPage ?? false, child: child);
      }
    },
    routes: [
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final isMobile = Platform.isAndroid || Platform.isIOS;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          if (isMobile && isPortrait) {
            return ChatList();
          } else {
            return ChatEmptyscreen();
          }
        },
        routes: [
          GoRoute(
            path: '/session',
            builder: (context, state) {
              return ChatDetailScreen();
            },
          ),
        ],
      ),
      GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
    ],
  );
}
