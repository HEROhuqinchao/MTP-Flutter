import 'package:flutter/material.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tablet, size: 100),
          const SizedBox(height: 20),
          Text(
            'Tablet Layout',
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
