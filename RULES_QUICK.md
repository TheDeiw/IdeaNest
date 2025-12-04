# ✅ FIREBASE RULES - КОРОТКИЙ ДОВІДНИК

## 📊 Firestore Database Rules

### Швидке посилання:
🔗 https://console.firebase.google.com/project/ideanest-2026/firestore/rules

### Правила (скопіюйте з файлу):
📄 `firestore.rules` в корені проекту

### Або скопіюйте звідси:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      match /notes/{noteId} {
        allow read, create, update, delete: if isOwner(userId);
      }
      match /tags/{tagId} {
        allow read, create, update, delete: if isOwner(userId);
      }
    }
  }
}
```

---

## 📁 Firebase Storage Rules

### Швидке посилання:
🔗 https://console.firebase.google.com/project/ideanest-2026/storage/rules

### Правила (скопіюйте з файлу):
📄 `storage.rules` в корені проекту

### Або скопіюйте звідси:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_photos/{userId} {
      allow read: if true;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.contentType.matches('image/.*')
                   && request.resource.size < 5 * 1024 * 1024;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

⚠️ **ВАЖЛИВО:** БЕЗ `.jpg` в match path!

---

## 🚀 Швидка настройка:

### 1. Firestore:
```
1. Відкрийте посилання вище
2. Ctrl+A → Delete (видалити все)
3. Вставте правила з firestore.rules
4. Publish
```

### 2. Storage:
```
1. Відкрийте посилання вище
2. Ctrl+A → Delete (видалити все)
3. Вставте правила з storage.rules
4. Publish
```

---

## ✅ Готово!

Детальна інформація в файлі: **FIREBASE_RULES_CURRENT.md**

