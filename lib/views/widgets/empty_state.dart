/// Empty State Widget - shown when no habits exist
/// Displays friendly message and CTA to create first habit
/// Follows fairy tale theme
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Build empty state with magical theme
    return const Center(child: Text('No habits yet'));
  }
}
