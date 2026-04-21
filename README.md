# 📝 NoteFlow

**NoteFlow** is a modern, production-ready Notes application built with Flutter, designed for speed, security, and seamless cloud synchronization. It leverages Clean Architecture and state-of-the-art technologies to provide a premium note-taking experience.

---

## ✨ Features

- **Real-time Cloud Sync**: Powered by Firebase Firestore for instantaneous data persistence across devices.
- **Offline-First**: Integrated with Hive for lightning-fast local data access and offline support.
- **Modern UI/UX**: Built with Material 3 design principles, featuring smooth animations and a responsive layout.
- **Advanced State Management**: Robust and scalable architecture using Riverpod and Code Generation.
- **Secure Authentication**: Multi-factor authentication support including Email/Password and Google Sign-In.
- **Rich Media**: Support for image attachments and storage via Firebase Storage.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Database (Local)**: [Hive](https://docs.hivedb.dev)
- **Backend (Cloud)**: [Firebase](https://firebase.google.com) (Auth, Firestore, Storage)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Dependency Injection**: [Riverpod](https://riverpod.dev)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.4.0)
- Firebase Account & Project
- `flutterfire_cli` installed

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/noteflow.git
   cd noteflow
   ```

2. **Setup Environment Variables**
   Create a `.env` file in the root directory and add your Firebase credentials:
   ```env
   FIREBASE_API_KEY=your_api_key
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_STORAGE_BUCKET=your_storage_bucket
   FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
   FIREBASE_ANDROID_APP_ID=your_android_app_id
   FIREBASE_WEB_APP_ID=your_web_app_id
   FIREBASE_IOS_APP_ID=your_ios_app_id
   IOS_BUNDLE_ID=your_ios_bundle_id
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run Code Generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

---

## 🏗️ Architecture

NoteFlow follows **Clean Architecture** patterns:
- **Core**: Cross-cutting concerns like routing, themes, and utilities.
- **Features**: Domain-driven modules containing:
  - `presentation`: UI components and Riverpod providers.
  - `domain`: Entity definitions and business logic.
  - `data`: Repository implementations and data sources (Firebase, Hive).

---

## 🔒 Security

This project uses environment variables via `flutter_dotenv` to protect sensitive API keys. Ensure the `.env` file is added to your `.gitignore` and never committed to version control.
