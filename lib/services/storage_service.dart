/// خدمة التخزين - تدير حفظ وتحميل البيانات محليًا
/// هذه الخدمة تتعامل مع shared_preferences لحفظ واسترجاع العادات
/// تتعامل أيضًا مع تحويل بيانات JSON

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class StorageService {
  // مفتاح التخزين - يستخدم لحفظ واسترجاع قائمة العادات
  // هذا الاسم موجود في shared_preferences كـ key
  static const String _habitsKey = 'habits_list';
  
  // المتغير الذي يحفظ نسخة من SharedPreferences بعد التهيئة
  late SharedPreferences _prefs; //بدي هيء قبل

  /// تهيئة خدمة التخزين initialize
  /// يجب استدعاء هذه الدالة عند بداية التطبيق حتى تكون shared_preferences جاهزة
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// حفظ جميع العادات إلى التخزين
  /// تأخذ قائمة من العادات وتحولها إلى نص JSON ثم تحفظها
  Future<void> saveHabits(List<Habit> habits) async {
    try {
      // تحويل كل كائن Habit إلى خريطة Map جاهزة للكتابة
      final jsonHabits = habits.map((habit) => habit.toJson()).toList();
      
      // تحويل الخريطة إلى نص JSON واحد
      // لأن shared_preferences تحفظ البيانات كنص فقط
      final jsonString = jsonEncode(jsonHabits);
      
      // حفظ النص في shared_preferences تحت نفس المفتاح
      await _prefs.setString(_habitsKey, jsonString);
      print('✅ Saved ${habits.length} habits successfully');
    } catch (e) {
      // إذا حدث خطأ أثناء التحويل أو الحفظ، يطبع رسالة وأعاد الخطأ
      print('❌ Error saving habits: $e');
      rethrow;
    }
  }

  /// تحميل جميع العادات من التخزين
  /// ترجع قائمة من العادات المحفوظة سابقًا
  Future<List<Habit>> loadHabits() async {
    try {
      // الحصول على النص المخزن من shared_preferences
      final jsonString = _prefs.getString(_habitsKey);
      
      // إذا لم يوجد نص، يعني ما في بيانات محفوظة بعد
      if (jsonString == null) {
        print('📋 No saved habits yet');
        return [];
      }
      
      // تحويل النص JSON مرة ثانية إلى قائمة من القيم
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      
      // لكل عنصر في القائمة، نحول من JSON إلى كائن Habit
      final habits = jsonList
          .map((json) => Habit.fromJson(json as Map<String, dynamic>))
          .toList();
      
      print('✅ Loaded ${habits.length} habits from storage');  
      return habits;
    } catch (e) {
      // إذا كان هناك خطأ في قراءة البيانات أو تحويلها
      print('❌ Error loading habits: $e');
      return [];
    }
  }

  /// حفظ عادة واحدة جديدة
  /// هذه الدالة تفتح التخزين، تضيف العادة إلى القائمة، ثم تحفظ القائمة المحدثة
  Future<void> addHabit(Habit newHabit) async {
    try {
      // أولًا نقرأ العادات الحالية من التخزين
      final habits = await loadHabits();
      
      // نضيف العادة الجديدة إلى القائمة
      habits.add(newHabit);
      
      // ثم نحفظ القائمة كلها مرة أخرى
      await saveHabits(habits);
      print('✅ Added habit: ${newHabit.name}');
    } catch (e) {
      print('❌ Error adding habit: $e');
      rethrow;
    }
  }

  /// تحديث عادة موجودة
  /// يبحث عن العادة الموجودة بالمعرّف ويستبدلها بالنسخة المحدثة
  Future<void> updateHabit(Habit updatedHabit) async {
    try {
      // تحميل العادات الموجودة
      final habits = await loadHabits();
      
      // العثور على موقع العادة المطابقة بالمعرّف
      //indexWhere ترجع موقع أول عنصر يحقق الشرط
      // أو -1 إذا لم تجد
      final index = habits.indexWhere((h) => h.id == updatedHabit.id);
      
      if (index != -1) {
        habits[index] = updatedHabit;
        await saveHabits(habits);
        print('✅ Updated habit: ${updatedHabit.name}');
      } else {
        // إذا العادة غير موجودة، نطبع تحذير ولا نحفظ
        print('⚠️ Habit not found with ID: ${updatedHabit.id}');
      }
    } catch (e) {
      print('❌ Error updating habit: $e');
      rethrow;
    }
  }

  /// حذف عادة محددة
  /// هذه الدالة تحذف العادة من القائمة ثم تحفظ القائمة الجديدة
  Future<void> deleteHabit(String habitId) async {
    try {
      // قراءة العادات من التخزين
      final habits = await loadHabits();
      
      // إزالة العادة التي رقمها يساوي habitId
      habits.removeWhere((h) => h.id == habitId);
      
      // حفظ القائمة بعد الحذف
      await saveHabits(habits);
      print('✅ Deleted habit with ID: $habitId');
    } catch (e) {
      print('❌ Error deleting habit: $e');
      rethrow;
    }
  }

  /// حذف جميع البيانات المحفوظة
  /// يستخدم فقط إذا أردنا مسح كل العادات المحفوظة
  Future<void> clearAllData() async {
    try {
      await _prefs.remove(_habitsKey);
      print('✅ All data deleted');
    } catch (e) {
      print('❌ Error deleting data: $e');
      rethrow;
    }
  }

  /// الحصول على عادة واحدة بناءً على الـ id
  /// ترجع null إذا لم تجد العادة
  Future<Habit?> getHabitById(String habitId) async {
    try {
      final habits = await loadHabits();
      return habits.firstWhere(
        (h) => h.id == habitId,
        orElse: () => throw FormatException('Habit not found'),
      );
    } catch (e) {
      print('⚠️ Habit not found: $e');
      return null;
    }
  }
}
