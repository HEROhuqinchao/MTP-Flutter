import 'package:flutter/material.dart';

class SimpleIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double? size;

  const SimpleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      style: ButtonStyle(
        // 设置背景透明
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        // 设置悬停时图标颜色变化
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return Theme.of(context).colorScheme.primary; // 悬停时变为主题主色
          }
          return Theme.of(context).colorScheme.onSurface; // 默认颜色
        }),
        // 消除点击效果
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        // 保持边框形状
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
