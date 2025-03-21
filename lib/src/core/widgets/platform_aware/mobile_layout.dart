import 'package:flutter/material.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android, size: 100),
          const SizedBox(height: 20),
          Text(
            'Mobile Layout',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Screen width: ${MediaQuery.of(context).size.width.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
