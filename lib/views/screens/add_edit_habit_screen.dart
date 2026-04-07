/// Add/Edit Habit Screen - form to create or modify habits
/// Simple text input for habit name with validation
/// Saves to controller on submit
import 'package:flutter/material.dart';

class AddEditHabitScreen extends StatelessWidget {
  const AddEditHabitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Build add/edit habit form with validation
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: const Center(child: Text('Add/Edit Habit')),
    );
  }
}
