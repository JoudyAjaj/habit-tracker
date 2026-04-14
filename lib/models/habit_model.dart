/// نموذج العادة - يخزن جميع بيانات العادة
/// هذا الصف يمثل عادة واحدة مع الاسم والتواريخ وتتبع الإكمال
class Habit {
  final String id; // معرف فريد لهذه العادة
  final String name; // اسم العادة (مثال: "قراءة كتاب"، "ممارسة الرياضة")
  final DateTime createdDate; // تاريخ إنشاء العادة
  DateTime? lastCompletedDate; // آخر يوم تم فيه تمييز العادة على أنها مكتملة
  final List<DateTime> completedDates; // جميع التواريخ التي اكتملت فيها العادة

  Habit({
    required this.id,
    required this.name,
    required this.createdDate,
    this.lastCompletedDate,
    List<DateTime>? completedDates,
  }) : completedDates = completedDates ?? []; //هون أنا اذا عملت العادة  بياخدها واذا لا  بحط ليست فاضية  

  /// التحقق مما إذا كانت العادة مكملة اليوم
  /// تعيد true فقط إذا كان lastCompletedDate هو اليوم الحالي
  bool get isCompletedToday {
    if (lastCompletedDate == null) return false;
    
    final today = DateTime.now();
    return lastCompletedDate!.year == today.year &&
        lastCompletedDate!.month == today.month &&
        lastCompletedDate!.day == today.day;
  }

  /// حساب السلسلة الحالية (أيام متتالية من الإنجاز)
  /// السلسلة = عدد الأيام المتتالية التي اكتملت فيها العادة (بدءًا من اليوم إلى الوراء)
  int calculateStreak() {  //كم يوم ورا بعض عملت العادة حساب الـ Streak
    if (completedDates.isEmpty) return 0;

    // ترتيب التواريخ ترتيبًا تنازليًا (الأحدث أولاً)
    final sortedDates = List<DateTime>.from(completedDates)
        ..sort((a, b) => b.compareTo(a));

    // إذا لم يكن آخر إكمال اليوم، تحقق ما إذا كان بالأمس
    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (final date in sortedDates) {
      // تطبيع التواريخ (تجاهل الوقت، قارن السنة/الشهر/اليوم فقط)
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final normalizedCurrent = DateTime(currentDate.year, currentDate.month, currentDate.day);

      // إذا كانت هذه التاريخ يطابق اليوم المتوقع في التسلسل، زد السلسلة
      if (normalizedDate.isAtSameMomentAs(normalizedCurrent)) {
        streak++;
        // انتقل إلى الأمس للتكرار التالي
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        // اكسر السلسلة إذا تم تفويت يوم
        break;
      }
    }

    return streak;
  }

  /// ضع علامة على هذه العادة كمكتملة اليوم
  void markAsDoneToday() {
    final today = DateTime.now();
    lastCompletedDate = DateTime(today.year, today.month, today.day);
    
    // أضف اليوم إلى قائمة التواريخ المكتملة إذا لم يكن موجودًا بالفعل
    if (!completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day)) {
      completedDates.add(DateTime(today.year, today.month, today.day));
    }
  }

  /// تحويل العادة إلى JSON للتخزين
  /// هذا يسمح لنا بحفظ العادات في shared_preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate.toIso8601String(),
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    };
  }

  /// إنشاء Habit من JSON (عند التحميل من التخزين)
  /// هذا يحول JSON المخزن مرة أخرى إلى كائن Habit
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.parse(json['lastCompletedDate'] as String)
          : null,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d as String))
              .toList() ??
          [],
    );
  }

  /// إنشاء نسخة من هذه العادة مع تغيير بعض الخصائص
  /// مفيد عند تحرير اسم العادة
  Habit copyWith({
    String? name,
    DateTime? lastCompletedDate,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      createdDate: createdDate,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      completedDates: List.from(completedDates),
    );
  }

  @override
  String toString() =>
      'Habit(id: $id, name: $name, streak: ${calculateStreak()}, completedToday: $isCompletedToday)';
}
