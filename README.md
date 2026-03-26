# 📱 SpeedMaths Pro  
### Advanced Math Training App (Flutter + Firebase + Hive)

SpeedMaths Pro is a hybrid **online + offline math practice app** designed to improve calculation speed, accuracy and consistency.  
It provides a competitive environment with daily ranked quizzes, practice modes, streaks, leaderboards, heatmaps, and detailed performance analytics.

---

## 🚀 Features

### 🎯 **Daily Ranked Quiz (Online)**
- Same questions for all users daily  
- Global leaderboard (Firebase)  
- Ranked streak tracking  
- Time-based scoring  
- Cached to minimize Firebase reads  

### 🧠 **Smart Practice (Offline: Hive)**
- Topic-wise practice: addition, subtraction, division, tables, averages etc.  
- Mixed quizzes  
- Unlimited questions  
- Instant accuracy & speed results  

### 📊 **Performance Analytics**
- Heatmap showing daily activity  
- Weekly / Monthly stats  
- Accuracy trends  
- Strengths & weaknesses  
- Mistake tracking engine  
- Personal best record  

### 📚 **Learning Section**
- Tables viewer (1–30)  
- Tricks, shortcuts, and formulas  
- Static offline content  

### 🧩 **Beautiful UI**
- Fully responsive custom layout  
- Light/Dark theme with adaptive text  
- Lottie animations  
- Smooth boot screen  
- Modern card-based layout  

---

## 🛠 **Tech Stack**

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | Firebase Auth, Firestore |
| **Offline DB** | Hive NoSQL |
| **State Management** | Provider |
| **Architecture** | Repository Pattern + Sync Manager (Offline-first) |
| **Caching** | Firebase cache layer |
| **UI/UX** | Custom responsiveness, animations, theme engine |

---

## 📐 **Folder Structure (Simplified)**

lib/
├── features/
│ ├── home/
│ ├── auth/
│ ├── quiz/
│ ├── performance/
│ └── learning/
├── services/
│ ├── app_initializer.dart
│ ├── auth_service.dart
│ ├── firebase_cache_service.dart
│ ├── hive_service.dart
│ └── sync_manager.dart
├── providers/
├── models/
├── theme/
└── widgets/


---

## 🧩 **Core Architecture Explained**

### 🔸 **Repository Pattern**
All Firebase + Hive operations go through a clean repository layer.  
UI never directly accesses Firestore or Hive.

### 🔸 **SyncManager**
Handles:
- Local data → Cloud sync  
- Cloud data → Local cache  
- Conflict resolution  
- Internet-loss recovery  

### 🔸 **Hybrid Online+Offline**
- Ranked quiz → Cloud  
- Everything else → Completely offline  

You can use this project as a real example of **production-ready offline-first architecture**.

---

## 📸 Screenshots
> *(Replace the placeholder images with actual screenshots once available.)*

| Home Screen | Ranked Quiz | Performance |
|------------|-------------|-------------|
| ![Home](screenshots/home.png) | ![Quiz](screenshots/quiz.png) | ![Performance](screenshots/performance.png) |

---

## 📥 Installation & Setup

### 1️⃣ Clone the repository
```sh
git clone https://github.com/your-username/speedmathspro.git
cd speedmathspro
