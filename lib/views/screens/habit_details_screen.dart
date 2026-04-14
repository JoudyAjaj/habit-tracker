/// Habit Details Screen - shows full habit information
/// Displays creation date, streak, completion history
/// Includes button to mark habit as done today
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../controllers/habit_controller.dart';
import '../../models/habit_model.dart';
import 'add_edit_habit_screen.dart';

class HabitDetailsScreen extends StatelessWidget {
  final String habitId;

  const HabitDetailsScreen({Key? key, required this.habitId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find<HabitController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final habit = controller.getHabitById(habitId);
              if (habit != null) {
                Get.to(() => AddEditHabitScreen(habit: habit));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        final habit = controller.getHabitById(habitId);
        if (habit == null) {
          return const Center(child: Text('Habit not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE6D4F5), Color(0xFFF5D5E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      child: Icon(
                        habit.isCompletedToday ? Icons.check_circle : Icons.local_fire_department,
                        size: 40,
                        color: habit.isCompletedToday ? Colors.green : const Color(0xFFB76E79),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A4A6F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      habit.isCompletedToday ? 'Completed Today ✨' : 'Not Completed Today',
                      style: TextStyle(
                        fontSize: 16,
                        color: habit.isCompletedToday ? Colors.green.shade700 : Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Current Streak',
                      '${habit.calculateStreak()} days',
                      Icons.star,
                      const Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Total Completions',
                      '${habit.completedDates.length} times',
                      Icons.calendar_today,
                      const Color(0xFFB76E79),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Creation Date
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6D4F5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_view_day, color: Color(0xFF9B7FA8)),
                    const SizedBox(width: 12),
                    Text(
                      'Creation Date: ${DateFormat('dd/MM/yyyy', 'en').format(habit.createdDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5A4A6F),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Mark as Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: habit.isCompletedToday
                      ? null
                      : () => controller.markHabitDone(habitId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: habit.isCompletedToday ? Colors.grey : const Color(0xFFB76E79),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: habit.isCompletedToday ? 0 : 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(habit.isCompletedToday ? Icons.check : Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        habit.isCompletedToday ? 'Completed Today' : 'Mark as Completed Today',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Completion History
              const Text(
                'Completion History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A4A6F),
                ),
              ),
              const SizedBox(height: 12),

              if (habit.completedDates.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Center(
                    child: Text(
                      'This habit has not been completed yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habit.completedDates.length,
                  itemBuilder: (context, index) {
                    final date = habit.completedDates[habit.completedDates.length - 1 - index]; // Newest first
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE6D4F5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEEE, dd/MM/yyyy', 'en').format(date),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A4A6F),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B7D9B),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HabitController controller) {
    final habit = controller.getHabitById(habitId);
    if (habit == null) return;
    final habitNameIsolated = '\u2068${habit.name}\u2069';

    Get.dialog(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          title: const Text(
            'Delete Habit',
            textAlign: TextAlign.left,
          ),
          content: Text(
            'Are you sure you want to delete "$habitNameIsolated"? This action cannot be undone.',
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteHabit(habitId);
                Get.back(); // Close dialog
                Get.back(); // Go back to list
                Get.snackbar(
                  'Habit Deleted',
                  'The habit has been deleted successfully',
                  titleText: const Text(
                    'Habit Deleted',
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                  ),
                  messageText: const Text(
                    'The habit has been deleted successfully',
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.red.shade800,
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
