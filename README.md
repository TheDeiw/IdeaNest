
# IdeaNest - Flutter Note Taking Application

📝 A comprehensive application for creating and organizing notes with tagging, search functionality, and full Firebase integration.

<img width="1920" height="1080" alt="Thumbnail1" src="https://github.com/user-attachments/assets/be0d08b6-d2e9-4614-9038-f4963c1115b1" />

Link to the design: https://www.figma.com/community/file/1595938384089942019/ideanest

---

## ✨ Features

### Implemented Functionality
*   **Authentication:** User Registration, Login, and Logout.
*   **User Profile:** View name, email, and profile photo.
    *   **Photo Upload:** Upload profile pictures directly to Firebase Storage.
    *   **Profile Editing:** Ability to update the display name.
*   **Session Management:** "Remember Me" functionality to stay logged in.
*   **Notes Management:** Full CRUD (Create, Read, Update, Delete) operations for notes.
*   **Tag System:** Full CRUD operations for tags.
*   **Search & Filter:**
    *   Search through notes.
    *   Filter notes by specific tags.
*   **Backend:**
    *   All data is stored in **Firebase Firestore** (no hardcoded data).
    *   **Security Rules** are configured for data protection.

---

## 🛠️ Tech Stack

*   **Framework:** Flutter 3.35.4
*   **Language:** Dart 3.9.2
*   **State Management:** Riverpod
*   **Backend:**
    *   **Firebase Auth:** User authentication.
    *   **Cloud Firestore:** Real-time database.
    *   **Firebase Storage:** File/Image storage.
*   **Plugins:** Image Picker (for profile photos).

---

## 📋 Installation

Follow these steps to set up the project locally:

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the application
flutter run
```

---


## 📱 Project Structure

```text
lib/
├── main.dart
└── src/
    ├── common/
    │   ├── services/
    │   │   └── storage_service.dart    # Image upload logic
    │   ├── providers/
    │   └── widgets/
    ├── features/
    │   ├── auth/                       # Authentication logic & UI
    │   ├── notes/                      # Notes CRUD
    │   ├── tags/                       # Tags CRUD
    │   └── settings/                   # Profile settings
    └── ...
```

---

## 👨‍💻 Development Commands

```bash
# Analyze code for errors and linting issues
flutter analyze

# Clean project build files
flutter clean
flutter pub get

# Run with verbose logging for debugging
flutter run --verbose
```

---
