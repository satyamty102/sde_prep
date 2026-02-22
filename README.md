# 🔥 SDE Prep - Interview Preparation Tracker

A **full-stack Flutter + Firebase mobile app** designed to gamify software engineering interview preparation. Track DSA problems, build daily habits, measure progress, and crush your interviews with data-driven insights.

**[🚀 Live Demo](https://sde-prep-app.web.app)** | **[📱 Add to iPhone Home Screen](#how-to-use)** | **[📚 Learn More](#tech-stack)**

---

## ✨ Overview

SDE Prep solves a critical problem: **Interview prep is fragmented**. You have LeetCode, HackerRank, a calendar, a notebook. This app unifies everything into one beautiful, mobile-first experience.

**Perfect for:**

- 🎯 Software engineers preparing for FAANG interviews
- 📈 Candidates who need structured learning + accountability
- 🔥 People who thrive on streaks and gamification
- 💪 Anyone serious about cracking the coding interview

---

## 🎬 Features

### **📊 Real-Time Dashboard**

- **Animated stat cards** showing Problems Solved, Streak 🔥, Roadmap %, Apps Sent
- **Daily motivational quote carousel** (swipeable, 10 rotating quotes)
- **Quick access** to today's checklist and progress

### **✅ Daily Task Checklist**

- 6 daily tasks (review, solve, study, watch, apply, journal)
- Auto-persist to Firebase Firestore
- Streak counter: Increments daily if all tasks completed
- ✨ Celebratory message when all done

### **🗺️ 24-Week Roadmap**

- 4 expandable phases with structured learning path:
  - **Phase 1:** Foundation (Weeks 1-4) - Arrays, Strings, Stack, Binary Search
  - **Phase 2:** Core DSA (Weeks 5-10) - Trees, Graphs, LinkedList, DP
  - **Phase 3:** Interview Mode (Weeks 11-16) - Mock interviews, System Design
  - **Phase 4:** Offer Season (Weeks 17-24) - Applications, Negotiation
- Progress bars per phase
- Accordion-style expandable weeks

### **💻 DSA Problem Tracker**

- **12 DSA topics** with 40+ LeetCode problems:
  - Arrays, Two Pointers, Sliding Window, HashMap, Stack, Binary Search, Linked List, Trees, Graphs, DP, Heap, Backtracking
- **Progress visualization:** Solved count, percentage, difficulty badges
- **Modal problem list:** Click any problem to toggle as solved
- **Real-time sync:** Changes save to Firebase instantly

### **🎯 Motivation Hub**

- "Hard truth" daily banner with interview insights
- Multi-page quote carousel (10 motivational quotes)
- 6 "Winning Tips" cards with icons (consistency, mock interviews, reading solutions, etc.)
- Encouragement section

### **🌙 Dark Theme + Smooth Animations**

- Premium dark mode (background: `#060608`, cards: `#1E1E2E`)
- 5 accent colors: Gold, Cyan, Purple, Green, Orange
- Smooth transitions on every interaction (animations, expandables, carousels)
- Responsive design (works on iPhone, iPad, desktop)

---

## 🛠️ Tech Stack

| Layer               | Technology                | Why?                                          |
| ------------------- | ------------------------- | --------------------------------------------- |
| **Frontend**        | Flutter (Dart)            | Cross-platform, smooth UI, native performance |
| **Backend**         | Firebase (Firestore)      | Real-time sync, serverless, no backend needed |
| **Auth**            | Firebase Auth             | Anonymous sign-in, persistent user ID         |
| **State Mgmt**      | Provider (ChangeNotifier) | Lightweight, reactive, easy to test           |
| **UI/Fonts**        | Material 3, Google Fonts  | Modern design, beautiful typography           |
| **Hosting**         | Firebase Hosting          | Free, fast, auto-HTTPS                        |
| **Version Control** | Git / GitHub              | Source control, portfolio showcase            |

---

## 🚀 Live Demo

**👉 [Open in Browser](https://sde-prep-app.web.app)**

### **On iPhone:**

1. Open Safari
2. Go to: `https://sde-prep-app.web.app`
3. Tap **Share** → **Add to Home Screen**
4. ✅ Now it's an app icon you can launch!

### **On Android:**

1. Open Chrome
2. Go to: `https://sde-prep-app.web.app`
3. Tap **⋮** (menu) → **Install app**
4. ✅ Added to home screen!

---

## 📱 How to Use

### **1. View Your Progress**

- **Home tab:** See stats, motivational quote, today's tasks
- **Daily Tracker tab:** Full task list + streak counter

### **2. Track DSA Problems**

- **DSA tab:** Click any topic card to see all problems
- **Check off problems** as you solve them
- Watch your progress % update in real-time

### **3. Follow the Roadmap**

- **Roadmap tab:** Click phases to expand and see week-by-week breakdown
- 24-week structure keeps you on track

### **4. Stay Motivated**

- **Motivation tab:** Read hard truths, get inspired, see winning tips
- New quote every day

---

## ⚙️ Setup & Running Locally

### **Prerequisites**

- Flutter SDK (v3.41+)
- Dart (included with Flutter)
- Firebase account (free tier works)
- Node.js (for Firebase CLI)

### **Installation**

```bash
# 1. Clone the repo
git clone https://github.com/satyamty102/sde_prep.git
cd sde_prep

# 2. Get dependencies
flutter pub get

# 3. Configure Firebase (already set up for this project)
flutterfire configure

# 4. Run on web
flutter run -d chrome

# 5. Or run on connected device
flutter run
```

### **Firebase Setup**

- Already configured in `firebase_options.dart`
- Anonymous sign-in enabled
- Firestore database in test mode
- No additional setup needed!

---

## 📦 Project Structure

```
lib/
├── main.dart                 # App entry, theme config
├── models/                   # Data classes
│   ├── user_stats.dart
│   ├── daily_task.dart
│   ├── dsa_topic.dart
│   └── index.dart
├── services/
│   └── firebase_service.dart # Firestore CRUD + streams
├── providers/
│   └── user_provider.dart    # State management (Provider)
├── widgets/                  # Reusable components
│   ├── difficulty_badge.dart
│   ├── stat_card.dart
│   ├── task_row.dart
│   ├── topic_card.dart
│   ├── phase_card.dart
│   └── index.dart
└── screens/                  # 5 main screens
    ├── home_screen.dart
    ├── roadmap_screen.dart
    ├── dsa_screen.dart
    ├── daily_tracker_screen.dart
    ├── motivation_screen.dart
    └── index.dart
```

---

## 🔌 Firebase Collections

```
users/{uid}
├── progress                 # Main stats: problems, streaks, apps
├── dailyTasks/{YYYY-MM-DD}  # Daily tasks (resets at midnight)
└── progress/dsa             # Topic-by-topic problem tracking
```

**Real-time Streams:** All data syncs automatically via Firestore listeners. Change from one device, see it instantly on another!

---

## 🎓 Key Technologies & Patterns

### **Flutter Concepts**

- ✅ StatelessWidget vs StatefulWidget
- ✅ AnimationController & Transitions (scale, rotation, size)
- ✅ GridView, PageView, BottomNavigationBar
- ✅ Provider pattern for reactive state
- ✅ Consumer widgets for rebuilding on data change
- ✅ Modal bottom sheets for detail views

### **Firebase Mastery**

- ✅ Firestore real-time streams (auto-sync)
- ✅ Anonymous authentication
- ✅ CRUD operations with error handling
- ✅ Offline fallback with SharedPreferences

### **State Management**

- ✅ ChangeNotifier pattern
- ✅ notifyListeners() for reactivity
- ✅ Separation of concerns (service layer + provider)

### **UI/UX**

- ✅ Dark theme consistency
- ✅ Micro-interactions (smooth animations)
- ✅ Responsive layouts
- ✅ Color psychology (green = success, gold = primary)

---

## 📊 Statistics

- **Lines of Code:** ~2,500 (clean, readable)
- **Screens:** 5 fully-built, navigable
- **Widgets:** 5 reusable components
- **DSA Topics:** 12 (with 40+ problems)
- **Daily Tasks:** 6 (customizable)
- **Animations:** 6+ smooth transitions
- **Firebase Collections:** 3 optimized schemas
- **Build Time:** <2 min on Windows

---

## 🚀 Deployment

### **Web (Firebase Hosting)**

```bash
flutter build web --release
firebase deploy --only hosting
```

✅ Live at: `https://sde-prep-app.web.app`

### **Android APK**

```bash
flutter build apk --release
# outputs: build/app/release/app-release.apk
```

### **iOS IPA** _(Requires Mac + Xcode)_

```bash
flutter build ipa
```

---

## 🎯 Future Enhancements

- [ ] **Push Notifications:** Daily 9am reminder
- [ ] **Charts:** Weekly problem count analytics (fl_chart)
- [ ] **Social Features:** Leaderboards, friend streaks
- [ ] **AI Coaching:** Claude API integration for hint system
- [ ] **Offline SQLite:** Local DB for better offline support
- [ ] **Problem Details:** Links to editorial + video explanations
- [ ] **Custom Roadmaps:** User-editable learning paths
- [ ] **Interview Recording:** Mock interview video storage

---

## 🤝 Contributing

Found a bug? Have ideas? Contributions welcome!

```bash
# 1. Fork the repo
# 2. Create a branch: git checkout -b feature/your-feature
# 3. Commit: git commit -m "Add feature"
# 4. Push: git push origin feature/your-feature
# 5. Open a Pull Request
```

---

## 📄 License

MIT License - feel free to use this project for learning and portfolio showcase!

---

## 💡 Why I Built This

I noticed that most engineers preparing for interviews juggle multiple tools:

- **LeetCode** for problems
- **Google Sheets** for tracking
- **Calendar** for scheduling
- **Notepad** for notes

This creates friction and lack of accountability. **SDE Prep** brings everything together with:

- ✅ Real-time progress tracking
- ✅ Daily habit enforcement (streaks)
- ✅ Structured 24-week learning path
- ✅ Beautiful, motivating UI
- ✅ Zero-friction data persistence

---

## 📞 Contact & Links

- **Live App:** [https://sde-prep-app.web.app](https://sde-prep-app.web.app)
- **GitHub:** [github.com/satyamty102/sde_prep](https://github.com)
- **Firebase Project:** `sde-prep-app`

---

## 🎉 Get Started

```bash
# Try it now
git clone https://github.com/[YOUR_USERNAME]/sde_prep.git
cd sde_prep
flutter pub get
flutter run -d chrome
```

Or open the [live demo](https://sde-prep-app.web.app) on your phone right now! 📱

---

**Built with ❤️ by a software engineer preparing for interviews. Good luck! 🚀**
