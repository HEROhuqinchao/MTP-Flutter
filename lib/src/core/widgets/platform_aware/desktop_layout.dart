import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtp/src/core/widgets/platform_aware/desktop_sidebar.dart';
import 'package:mtp/src/core/widgets/responsive_layout.dart';

class DesktopLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showDivider;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const DesktopLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showDivider = true,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPhysicalMobile = context.isPhysicalMobile;

    if (isPhysicalMobile) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
        floatingActionButton: floatingActionButton,
        appBar:
            appBar ??
            (title != null
                ? AppBar(
                  title: Text(title!),
                  actions: actions,
                  scrolledUnderElevation: 0,
                )
                : null),
        body: child,
      );
    }

    // Standard desktop layout
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            // 固定宽度的侧边栏
            if (!(Platform.isAndroid || Platform.isIOS)) const DesktopSidebar(),

            // 可选的分隔线
            if (showDivider)
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor.withOpacity(0.1),
              ),

            // 内容区域 - 使用Expanded填充剩余空间
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar:
                    appBar ??
                    (title != null
                        ? AppBar(
                          title: Text(title!),
                          actions: actions,
                          scrolledUnderElevation: 0, // 避免滚动时的阴影
                          backgroundColor:
                              theme.appBarTheme.backgroundColor ??
                              theme.colorScheme.surface,
                        )
                        : null),
                body: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
