/// Habit controller - manages state using GetX
/// This file handles business logic for habits:
/// loading, adding, updating, deleting, and marking done.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/habit_model.dart';
import '../services/storage_service.dart';

class HabitController extends GetxController {
  // ‎خدمة التخزين التي تتعامل مع shared_preferences
  final StorageService _storageService = StorageService();


  // ‎قائمة العادات التفاعلية. أي تغيير فيها يحدث تحديثًا تلقائيًا للواجهة.
  final RxList<Habit> habits = <Habit>[].obs;

  // ‎حالة التحميل - يمكن استخدامها لعرض مؤشر انتظار إذا أردنا.
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  /// تهيئة وحدة التحكم: تهيئة خدمة التخزين ثم تحميل العادات.
  Future<void> _initializeController() async {
    isLoading.value = true;
    await _storageService.initialize();
    await loadHabits();
    isLoading.value = false;
  }

  /// تحميل العادات من التخزين إلى الذاكرة.
  Future<void> loadHabits() async {
    final loadedHabits = await _storageService.loadHabits();
    habits.assignAll(loadedHabits);
  }

  /// إضافة عادة جديدة.
  Future<void> addHabit(String name) async {
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdDate: DateTime.now(),
    );

    habits.add(newHabit);
    await _storageService.saveHabits(habits.toList());
  }

  /// تحديث اسم العادة الموجودة.
  Future<void> updateHabit(String habitId, String newName) async {
    final index = habits.indexWhere((habit) => habit.id == habitId);
    if (index == -1) return;

    final updatedHabit = habits[index].copyWith(name: newName);
    habits[index] = updatedHabit;
    await _storageService.saveHabits(habits.toList());
  }

  /// حذف عادة من القائمة.
  Future<void> deleteHabit(String habitId) async {
    habits.removeWhere((habit) => habit.id == habitId);
    await _storageService.saveHabits(habits.toList());
  }

  /// تعيين العادة على أنها مكتملة اليوم.
  Future<void> markHabitDone(String habitId) async {
    final index = habits.indexWhere((habit) => habit.id == habitId);
    if (index == -1) return;

    habits[index].markAsDoneToday();
    habits.refresh();
    await _storageService.saveHabits(habits.toList());

    Get.snackbar(
      'Success',
      'Habit updated: ${habits[index].name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: const Duration(seconds: 2),
    );
  }

  /// الحصول على عادة واحدة بناءً على المعرّف.
  Habit? getHabitById(String habitId) {
    return habits.firstWhereOrNull((habit) => habit.id == habitId);
  }
}
