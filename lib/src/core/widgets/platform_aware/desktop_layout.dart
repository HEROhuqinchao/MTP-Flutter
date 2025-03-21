import 'package:flutter/material.dart';
import 'package:mtp/src/core/widgets/platform_aware/desktop_sidebar.dart';
import 'package:mtp/src/presentation/pages/chat_screen/chat_screen.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [DesktopSidebar(), Expanded(child: ChatScreen())]);
  }
}
