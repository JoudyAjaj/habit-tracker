/// Empty State Widget - shown when no habits exist
/// Displays friendly message and CTA to create first habit
/// Follows fairy tale theme
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/add_edit_habit_screen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE6D4F5), Color(0xFFF5D5E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 80,
                color: Color(0xFFB76E79),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No habits yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A4A6F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start your magical journey by adding a new habit and track your progress day by day.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF8B7D9B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const AddEditHabitScreen()),
              icon: const Icon(Icons.add),
              label: const Text('Create First Habit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB76E79),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
