# Habit Tracker App - Development Plan

## 🎯 Project Overview
Build a habit tracker application that helps users establish daily habits by tracking completion streaks, managing habit data locally, and providing a clean user interface.

---

## 📋 Feature Checklist

### Core Features
- ✅ Add a new habit with a name
- ✅ Mark a habit as done for today (once per day only)
- ✅ Streak counter — consecutive days completed
- ✅ Edit a habit name
- ✅ Delete a habit with a confirmation dialog
- ✅ Persist all data locally with `shared_preferences`
- ✅ Empty state on list screen when no habits exist

### Screens
1. **Habits List Screen** — Display all habits with streak counter
2. **Add/Edit Habit Screen** — Create or modify habit details
3. **Habit Details Screen** — View full habit history and statistics

---

## 🏗 Architecture Overview

### Why MVC + GetX?
- **MVC (Model-View-Controller)**: Separates code into three layers for clarity
  - **Model**: Habit data and business logic
  - **View**: UI screens (Flutter widgets)
  - **Controller**: Manages state and handles user actions
- **GetX**: State management library that makes MVC easy with reactive updates

### Project Structure
```
lib/
├── models/
│   └── habit_model.dart          # Habit data structure
├── controllers/
│   └── habit_controller.dart      # State management (GetX)
├── views/
│   ├── screens/
│   │   ├── habits_list_screen.dart
│   │   ├── add_edit_habit_screen.dart
│   │   └── habit_details_screen.dart
│   └── widgets/
│       ├── habit_card.dart        # Reusable habit card
│       ├── empty_state.dart       # Empty state display
│       └── streak_display.dart    # Streak badge
├── services/
│   └── storage_service.dart       # Local storage (shared_preferences)
├── utils/
│   ├── constants.dart             # App-wide constants
│   └── theme.dart                 # Colors and styling
└── main.dart
```

---

## 🔄 Phase-by-Phase Development

### **Phase 1: Setup & Foundation** (Step 1-3)
Initialize the project and set up the basic architecture.

**Step 1**: Add required dependencies
- `get` — State management
- `shared_preferences` — Local storage
- `intl` — Date formatting

**Step 2**: Create the Habit Model
- Define habit properties: `id`, `name`, `createdDate`, `lastCompletedDate`, `streak`
- Add methods to calculate if completed today

**Step 3**: Create Storage Service
- Set up `shared_preferences` for saving/loading habits
- Handle JSON serialization

---

### **Phase 2: State Management** (Step 4)
Build the HabitController using GetX.

**Step 4**: Create HabitController
- Load habits from storage on app start
- Implement methods:
  - `addHabit()`
  - `updateHabit()`
  - `deleteHabit()`
  - `markHabitDone()`
  - `calculateStreak()`
- Use GetX `Rx` for reactive updates

---

### **Phase 3: UI - List & Empty State** (Step 5-6)
Build the habits list screen with beautiful design.

**Step 5**: Create Habits List Screen
- Display all habits in a `ListView` or `GridView`
- Show habit name, today's status, and streak
- Add FAB (Floating Action Button) to add new habit

**Step 6**: Create Empty State Widget
- Show friendly message when no habits exist
- Add call-to-action button to create first habit

---

### **Phase 4: Add/Edit Habit Screen** (Step 7)
Build the form to create and edit habits.

**Step 7**: Create Add/Edit Habit Screen
- Simple text input for habit name
- Validation (name not empty)
- Save button to add/update habit
- Navigate back to list after saving

---

### **Phase 5: Habit Details & Actions** (Step 8-10)
Add detailed view and user interactions.

**Step 8**: Create Habit Details Screen
- Show habit name, creation date, streak
- Display calendar or list of completion dates
- Mark as done button

**Step 9**: Mark Habit as Done
- Update `lastCompletedDate`
- Recalculate streak
- Prevent marking twice in one day
- Show visual feedback (toast/snackbar)

**Step 10**: Delete with Confirmation
- Show confirmation dialog
- Delete from storage on confirm
- Navigate back to list

---

### **Phase 6: Polish & Testing** (Step 11-12)
Refine UI/UX and ensure data persistence.

**Step 11**: Apply Beautiful Design
- Use consistent color scheme
- Add smooth animations
- Improve visual hierarchy
- Handle loading states

**Step 12**: Test Data Persistence
- Verify habits save after app restart
- Test editing and deletion
- Check streak calculations

---

## 🎨 Design Guidelines

### Color Scheme (Suggestion)
- **Primary**: Fresh blue or teal (modern, energetic)
- **Accent**: Green (for completion/success)
- **Background**: Light gray or white (clean)
- **Text**: Dark gray or black (readable)

### UI Elements
- **Habit Card**: Clean white card with rounded corners, soft shadow
- **Streak Badge**: Green circle/pill with number (e.g., "7 days 🔥")
- **Buttons**: Rounded, generous padding, clear labels
- **Empty State**: Large icon + message + action button

### UX Patterns
- Swipe to delete (optional nice-to-have)
- Haptic feedback on mark complete
- Smooth navigation transitions
- Success animations

---

## 🔑 Key Concepts to Learn

### 1. GetX Reactive (Rx)
```dart
// Variables update UI automatically
final habits = RxList<Habit>();
```

### 2. Streak Calculation
Calculate consecutive days between `lastCompletedDate` and today.

### 3. Data Serialization
Convert Habit objects to/from JSON for storage.

### 4. Local Storage with shared_preferences
Save/load data as JSON strings.

---

## 📝 Step-by-Step Summary

| Phase | Steps | Focus |
|-------|-------|-------|
| 1 | 1-3 | Dependencies, Model, Storage |
| 2 | 4 | State Management |
| 3 | 5-6 | List Screen & Empty State |
| 4 | 7 | Add/Edit Screen |
| 5 | 8-10 | Details, Mark Done, Delete |
| 6 | 11-12 | Design & Testing |

---

## 🚀 Ready to Start?
Each phase builds on the previous one. Once you complete Phase 1, you'll have a solid foundation to add features easily.

**Next Step**: Begin with Phase 1, Step 1 — adding dependencies to `pubspec.yaml`.

Do you want to start with Phase 1, or do you have questions about the plan?
