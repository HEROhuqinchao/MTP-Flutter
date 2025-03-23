import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/app/routes.dart';
import 'package:mtp/src/app/theme/app_theme.dart';
import 'package:mtp/src/presentation/providers/settings/settings_provider.dart';

class MobileLayout extends ConsumerWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取当前主题模式
    final themeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        // 设置主题
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
      ),
    );
  }
}
