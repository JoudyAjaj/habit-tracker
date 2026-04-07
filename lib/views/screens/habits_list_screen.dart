/// Habits List Screen - main screen showing all habits
/// Displays habit cards with streak counter
/// Includes FAB to add new habits and empty state when no habits exist
import 'package:flutter/material.dart';

class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Build habits list UI with GetX state management
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: const Center(child: Text('Habits List')),
    );
  }
}
