/// Habits List Screen - main screen showing all habits
/// Displays habit cards with streak counter
/// Includes FAB to add new habits and empty state when no habits exist
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/habit_controller.dart';
import '../widgets/habit_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_habit_screen.dart';
import 'habit_details_screen.dart';


//شاشة بتعرض كل العادات
//زر + لاضافة عادة
// شاشة فاضية إذا مافي عادات

class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find<HabitController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAppInfoDialog(context),
          ),
        ],
      ),
                  //    شو هو Obx؟

                 // تابع لـ Get .

                 // بيعمل إعادة بناء تلقائي (Reactive)

                 // لما تتغير البيانات - الشاشة تتحدث مباشرة

      
      body: Obx(() {
        if (controller.habits.isEmpty) {
          return const EmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.habits.length,
          itemBuilder: (context, index) {
            final habit = controller.habits[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HabitCard(
                habit: habit,
                onTap: () {
                 Get.to(() => HabitDetailsScreen(habitId: habit.id));
                },
                onMarkDone: () {
                  controller.markHabitDone(habit.id);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB76E79),
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const AddEditHabitScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Habit Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.track_changes,
        size: 36,
        color: Color(0xFFB76E79),
      ),
      children: const [
        SizedBox(height: 8),
        Text(
          'Track your daily habits, build streaks, and stay consistent every day.',
        ),
      ],
    );
  }
}
