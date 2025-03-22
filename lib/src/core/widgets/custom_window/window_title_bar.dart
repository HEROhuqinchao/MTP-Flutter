import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:window_manager_plus/window_manager_plus.dart';

class WindowTitleBar extends StatelessWidget {
  final Color? backgroundColor;
  final double height;
  final VoidCallback? onReset;

  const WindowTitleBar({
    super.key,
    this.backgroundColor,
    this.height = 32.0,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        WindowManagerPlus.current.startDragging();
      },
      onDoubleTap: () async {
        if (await WindowManagerPlus.current.isMaximized()) {
          WindowManagerPlus.current.unmaximize();
        } else {
          WindowManagerPlus.current.maximize();
        }
      },
      child: Container(
        height: height,
        // 使用半透明背景，使下方内容可见
        color: backgroundColor ?? Colors.transparent,
        child: Row(
          children: [
            const Spacer(),
            if (onReset != null)
              IconButton(
                icon: Icon(Ionicons.refresh, size: 16),
                onPressed: onReset,
                tooltip: '重置为默认设置',
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
            _WindowButton(
              icon: Ionicons.remove,
              onPressed: () => WindowManagerPlus.current.minimize(),
            ),
            _WindowButton(
              icon: Ionicons.square_outline,
              onPressed: () async {
                if (await WindowManagerPlus.current.isMaximized()) {
                  WindowManagerPlus.current.unmaximize();
                } else {
                  WindowManagerPlus.current.maximize();
                }
              },
            ),
            _WindowButton(
              icon: Ionicons.close,
              onPressed: () => WindowManagerPlus.current.close(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _WindowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 16,
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
