# 📱 SpeedMaths Pro

### Advanced Math Training App — Flutter, Firebase & Hive

SpeedMaths Pro is an offline-first math practice app designed to improve calculation speed, accuracy, and consistency through daily quizzes, smart practice, analytics, and competitive rankings.

> **Status:** Currently in the deployment stage and awaiting Google Play Store approval.

## 🚀 Features

- **Daily Ranked Quiz:** Same daily questions for all users, time-based scoring, global leaderboard, and streak tracking.
- **Smart Practice:** Unlimited offline topic-wise and mixed quizzes using Hive.
- **Performance Analytics:** Activity heatmaps, accuracy trends, strengths, weaknesses, mistake tracking, and personal-best records.
- **Learning Section:** Tables (1–30), tricks, shortcuts, and formulas available offline.
- **Modern UI:** Responsive layouts, light/dark mode, Lottie animations, and smooth user experience.

## 🛠 Tech Stack

| Layer | Technology |
| --- | --- |
| Frontend | Flutter (Dart) |
| Backend | Firebase Authentication, Cloud Firestore |
| Offline Database | Hive NoSQL |
| State Management | Provider |
| Architecture | Repository Pattern + Sync Manager |
| UI/UX | Responsive design, animations, theme engine |

## 🧩 Architecture

The app follows an offline-first approach:

- Firebase and Hive access is handled through a repository layer.
- The UI does not directly access Firestore or Hive.
- `SyncManager` manages local-to-cloud synchronization, caching, conflict handling, and recovery after connectivity loss.
- Daily ranked quizzes require an internet connection; practice, learning content, and much of the performance data remain available offline.

## 📁 Project Structure

```text
lib/
├── features/
│   ├── home/
│   ├── auth/
│   ├── quiz/
│   ├── performance/
│   └── learning/
├── services/
│   ├── app_initializer.dart
│   ├── auth_service.dart
│   ├── firebase_cache_service.dart
│   ├── hive_service.dart
│   └── sync_manager.dart
├── providers/
├── models/
├── theme/
└── widgets/
```

## 📸 Screenshots

| Home Screen | Ranked Quiz | Performance |
| --- | --- | --- |
| ![Home](screenshots/home.png) | ![Quiz](screenshots/quiz.png) | ![Performance](screenshots/performance.png) |

> Replace these placeholders with final app screenshots after Play Store approval.

## 📥 Installation

```bash
git clone https://github.com/siddhantxcodes/speedmathspro.git
cd speedmathspro
flutter pub get
flutter run
```

## 🔐 Firebase Setup

Create and configure a Firebase project, then add the platform configuration files before running the app:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Do not commit Firebase credentials or sensitive configuration files to a public repository.

## 📦 Build for Release

```bash
flutter build appbundle
```

The generated Android App Bundle will be available in:

```text
build/app/outputs/bundle/release/app-release.aab
```

## 📄 License

© 2026 Siddhant Mishra. All rights reserved.

This project is proprietary and shared for portfolio and demonstration purposes only. Copying, modifying, or redistributing any part of the source code or design without written permission is not allowed.
