<div align="center">

<br/>

```
███████╗██╗████████╗███╗   ██╗███████╗███████╗███████╗
██╔════╝██║╚══██╔══╝████╗  ██║██╔════╝██╔════╝██╔════╝
█████╗  ██║   ██║   ██╔██╗ ██║█████╗  ███████╗███████╗
██╔══╝  ██║   ██║   ██║╚██╗██║██╔══╝  ╚════██║╚════██║
██║     ██║   ██║   ██║ ╚████║███████╗███████║███████║
╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝
                        T R A C K E R
```

### Track smarter. Train harder. Progress visually.

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC](https://img.shields.io/badge/BLoC-Cubit-8B5CF6?style=for-the-badge)](https://bloclibrary.dev)
[![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-22C55E?style=for-the-badge)](https://blog.cleancoder.com)
[![SQLite](https://img.shields.io/badge/SQLite-Local%20DB-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)
[![License](https://img.shields.io/badge/License-MIT-F59E0B?style=for-the-badge)](LICENSE)

<br/>

> A production-quality Flutter fitness app built with Clean Architecture, BLoC/Cubit, SQLite, and fl_chart.  
> Fully offline · Dark & Light Mode · Animated · 58+ files · Tested.

<br/>

<!-- 🎬 REPLACE THIS with your actual demo video or GIF -->
<!-- ![Demo](assets/demo/demo.gif) -->

---

</div>

## ✨ What's Inside

| # | Feature | Details |
|---|---|---|
| 🏠 | **Home — Workout Log** | Create named sessions (Push Day, Leg Day…), log sets with exercise + reps + weight, live volume counter, swipe-to-delete with confirmation |
| 📚 | **Exercise Library** | 36 pre-seeded exercises across 7 muscle groups, horizontal filter chips per group, real-time search by name or muscle |
| 📈 | **Progress Charts** | Per-exercise fl_chart line charts, toggle between Max Weight and Total Volume, Personal Records card with animated counters |
| 🤖 | **Workout Generator** | Rule-based plan generator — pick goal × level × days/week → get a full weekly split (PPL, Upper/Lower, Full Body) |
| 🌙 | **Theme Toggle** | Animated dark ↔ light switch in Profile tab, persisted via SharedPreferences across app restarts |
| ✨ | **Animations** | Staggered list reveals, shimmer skeleton loading, animated counters, spring FAB, floating avatar, tab fade transitions |
| 🗄️ | **Offline First** | 100% local — SQLite with 3 relational tables, no internet required, no backend |

---

## 📱 Screens

| Home | Workout Detail | Progress | Generator | Profile |
|:---:|:---:|:---:|:---:|:---:|
| ![](assets/demo/home.png) | ![](assets/demo/detail.png) | ![](assets/demo/progress.png) | ![](assets/demo/generator.png) | ![](assets/demo/profile.png) |
| Session list + FAB | Log sets per exercise | fl_chart + PR card | 3-question form | Theme toggle |

> 📸 Add your own screenshots to `assets/demo/` and replace the placeholders above.

---

## 🎬 Demo Video

> Upload your screen recording to GitHub and paste the link below.  
> **How to upload a video to GitHub README** → see [Upload Guide](#-how-to-upload-a-video-to-github) at the bottom.

<!-- Replace this URL after uploading your video -->
```
https://github.com/user-attachments/assets/YOUR-VIDEO-ID-HERE
```

---

## 🏗️ Architecture

Built with **Clean Architecture + MVVM**, strictly enforcing the dependency rule: outer layers depend on inner layers, never the reverse.

```
Presentation  ──►  Domain  ◄──  Data
(Cubit/Pages)    (Entities,    (Models,
                  Repos,        Datasources,
                  UseCases)     RepoImpl)
```

### Folder Structure

```
lib/
│
├── core/
│   ├── animations_helper/        # AnimatedListItem, ShimmerBox, AnimatedCounter,
│   │                             # PulsingDot, FloatingWidget, page transitions
│   ├── database/
│   │   └── database_helper.dart  # Singleton SQLite helper — 3 tables + seed data
│   ├── di/
│   │   └── service_locator.dart  # GetIt — all dependencies registered here
│   ├── routing/
│   │   └── app_routing.dart      # Named routes: /, /workout-detail, /exercise-library
│   └── theme/
│       ├── app_colors.dart       # All color constants (dark + muscle group colors)
│       ├── app_theme.dart        # Full ThemeData for dark + light modes
│       └── cubit/
│           └── theme_cubit.dart  # ThemeMode state + SharedPreferences persistence
│
├── features/
│   │
│   ├── exercise_library/
│   │   ├── data/
│   │   │   ├── datasourcse/      # ExerciseLocalDatasource (getAllExercises, search…)
│   │   │   ├── models/           # ExerciseModel (fromMap / toMap)
│   │   │   └── repoImpl/         # ExerciseRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/         # Exercise (Equatable)
│   │   │   ├── repos/            # ExerciseRepository (abstract)
│   │   │   └── usecases/         # GetExercisesUsecase (all / byMuscleGroup / search)
│   │   └── presentation/
│   │       ├── cubit/            # ExerciseCubit + ExerciseState
│   │       ├── pages/            # ExerciseLibraryPage
│   │       └── widgets/          # ExerciseCard, MuscleGroupFilter
│   │
│   ├── work_log/
│   │   ├── data/
│   │   │   ├── datasources/      # WorkoutLocalDatasource (JOIN queries)
│   │   │   └── repoImp/          # WorkoutRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/         # WorkoutSession, WorkoutSet (Equatable)
│   │   │   ├── repos/            # WorkoutRepository (abstract)
│   │   │   └── usecases/         # CreateSession, AddSet, GetSessions, DeleteSession
│   │   ├── models/               # WorkoutSessionModel, WorkoutSetModel
│   │   └── presentation/
│   │       ├── cubits/           # WorkoutCubit + WorkoutState
│   │       ├── pages/            # HomePage, WorkoutDetailPage
│   │       └── widgets/          # SessionCard, SetTile, NewSessionBottomSheet,
│   │                             # AddSetBottomSheet
│   │
│   ├── work_progress/
│   │   ├── data/                 # ProgressLocalDatasource (raw SQL aggregations)
│   │   ├── domain/
│   │   │   ├── entities/models/  # ExerciseProgress, ProgressEntry
│   │   │   ├── repos/            # ProgressRepository (abstract)
│   │   │   └── usecases/         # GetProgressUsecase
│   │   └── presentation/
│   │       ├── cubits/           # ProgressCubit + ProgressState
│   │       └── pages/            # ProgressPage (fl_chart)
│   │
│   ├── work_generator/
│   │   ├── data/usecases/        # GenerateWorkoutUsecase (pure rule-based logic)
│   │   ├── domain/               # GeneratorInput, GeneratedWorkoutDay,
│   │   │                         # GeneratedExercise, FitnessGoal/Level/Days enums
│   │   └── presentation/
│   │       ├── cubits/           # GeneratorCubit + GeneratorState
│   │       └── pages/            # WorkoutGeneratorPage
│   │
│   └── profile_page.dart         # Animated theme toggle + stats + about
│
├── main_shell.dart               # Bottom nav (Home / Progress / Generate / Profile)
│                                 # + PageTransitionSwitcher (fade+slide)
└── main.dart                     # Entry point — MultiBlocProvider + ThemeCubit
```

### Database Schema

```sql
┌─────────────────────┐    ┌──────────────────────────────┐
│     exercises       │    │       workout_sessions        │
│─────────────────────│    │──────────────────────────────│
│ id       INTEGER PK │    │ id            INTEGER PK      │
│ name     TEXT       │    │ name          TEXT            │
│ muscle_group TEXT   │    │ date          TEXT (ISO8601)  │
│ description  TEXT   │    │ notes         TEXT            │
└─────────────────────┘    │ duration_minutes INTEGER      │
          │                └──────────────────────────────┘
          │                              │
          └──────────┐   ┌───────────────┘
                     ▼   ▼
           ┌─────────────────────┐
           │     workout_sets    │
           │─────────────────────│
           │ id          INT PK  │
           │ session_id  INT FK  │◄── CASCADE DELETE
           │ exercise_id INT FK  │
           │ set_number  INT     │
           │ reps        INT     │
           │ weight      REAL    │
           └─────────────────────┘
```

---

## 🛠️ Tech Stack

| Category | Package | Why |
|---|---|---|
| State Management | `flutter_bloc` | Cubit keeps logic clean, testable, no boilerplate |
| Dependency Injection | `get_it` | Lazy singleton / factory registration |
| Local Database | `sqflite` + `path` | Full relational power, offline-first |
| Charts | `fl_chart` | Smooth, customizable line charts |
| Persistence | `shared_preferences` | Theme preference across restarts |
| Icons | `iconsax` | Consistent icon set throughout the app |
| Equality | `equatable` | Value equality for Entities and States |
| Testing | `bloc_test` + `mocktail` | Mock Cubits, test state sequences |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK `>=3.0.0`
- Android emulator, iOS simulator, or a physical device

### Run Locally

```bash
# 1. Clone the repo
git clone https://github.com/Mohamednasr11/fitness_tracker.git
cd fitness_tracker

# 2. Install dependencies
flutter pub get

# 3. Run on your device/emulator
flutter run
```

> ✅ No API keys. No backend setup. The SQLite database is created automatically on first launch with 36 pre-seeded exercises.

### Build APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run a specific file
flutter test test/features/exercise_library/presentation/pages/exercise_library_page_test.dart
```

### Coverage Summary

| Test File | Coverage |
|---|---|
| `exercise_library_page_test` | Page renders, cubit called on load |
| `workout_generator_page_test` | All 3 states (initial/loading/loaded), button calls cubit |
| `home_page_test` | Empty state, loading state |
| `workout_detail_page_test` | Session renders, empty sets message |
| `main_shell_test` | BottomNavigationBar renders |

---

## 🎨 UI Details

### Colors (Dark Mode)
```dart
primary:         #00E5FF   // Cyan accent
background:      #0A0A0A   // Near-black
card:            #1A1A1A
surface:         #141414
divider:         #2A2A2A
```

### Muscle Group Colors
```
Chest     #EF5350 (Red)       Back      #42A5F5 (Blue)
Legs      #AB47BC (Purple)    Shoulders #FF7043 (Orange)
Arms      #26C6DA (Teal)      Core      #66BB6A (Green)
Cardio    #FFCA28 (Yellow)
```

### Animations Used
- `AnimatedListItem` — staggered slide+fade on list items
- `ShimmerBox` / `SessionCardSkeleton` — skeleton loading state
- `AnimatedCounter` — counts up from 0 to value (800ms, easeOutCubic)
- `FloatingWidget` — gentle vertical float for avatar
- `AnimatedSwitcher` — icon rotation on theme toggle
- `PageTransitionSwitcher` — fade+slide between bottom nav tabs
- `TweenAnimationBuilder` — staggered entrance on SetTile rows

---

## 🔮 Roadmap

- [ ] Rest timer between sets with haptic feedback
- [ ] Body weight & measurements tracker
- [ ] Workout streak counter
- [ ] Export data as CSV
- [ ] Firebase sync for backup
- [ ] Push notifications for workout reminders
- [ ] Play Store release

---

## 📤 How to Upload a Video to GitHub

GitHub lets you embed videos directly in your README — no third-party hosting needed.

**Steps:**

1. Go to your repo on GitHub
2. Click **Issues** → **New Issue**
3. In the comment box, **drag and drop** your `.mp4` recording
4. Wait for the upload — GitHub gives you a URL like:
   ```
   https://github.com/user-attachments/assets/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```
5. **Copy that URL** — then close/discard the issue (no need to submit it)
6. Paste it in your README like this:

```markdown
https://github.com/user-attachments/assets/YOUR-VIDEO-ID
```

Or as a clickable thumbnail:
```markdown
[![Watch Demo](assets/demo/thumbnail.png)](https://github.com/user-attachments/assets/YOUR-VIDEO-ID)
```

---

## 👨‍💻 Author

<div align="center">

**Mohamed Nasr Eldeen**  
Flutter Developer · CS Student @ Mansoura University

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Mohamed%20Nasr%20Eldeen-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/mohamed-nasr-eldeen-3057b8240)
[![GitHub](https://img.shields.io/badge/GitHub-Mohamednasr11-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Mohamednasr11)
[![Email](https://img.shields.io/badge/Email-mohamed.nasr.flutter%40gmail.com-EA4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mohamed.nasr.flutter@gmail.com)

</div>

---

## 📄 License

```
MIT License

Copyright (c) 2026 Mohamed Nasr Eldeen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.
```

---

<div align="center">

**⭐ If this project helped you or inspired you, drop a star — it means a lot!**

*Built with 💙 Flutter — from Mansoura, Egypt*

</div>
