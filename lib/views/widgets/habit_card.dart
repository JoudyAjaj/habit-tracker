/// Habit Card Widget - reusable card component
/// Displays single habit with name, status, and streak
/// Used in the habits list screen
import 'package:flutter/material.dart';
import '../../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;

  const HabitCard({
    Key? key,
    required this.habit,
    this.onTap,
    this.onMarkDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusText = habit.isCompletedToday ? 'Completed Today' : 'Not Completed';
    final statusColor = habit.isCompletedToday ? Colors.green.shade700 : Colors.orange.shade700;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF5D5E0), Color(0xFFE6D4F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Icon(
                  habit.isCompletedToday ? Icons.check_circle : Icons.local_fire_department,
                  color: habit.isCompletedToday ? Colors.green : Colors.deepPurple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4A6F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Color(0xFF9B7FA8)),
                        const SizedBox(width: 6),
                        Text(
                          '${habit.calculateStreak()} يوم متتالية',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5A4A6F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: habit.isCompletedToday ? null : onMarkDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: habit.isCompletedToday ? Colors.grey : const Color(0xFFB76E79),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  elevation: habit.isCompletedToday ? 0 : 4,
                ),
                child: Text(
                  habit.isCompletedToday ? 'Completed' : 'Complete Now',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
