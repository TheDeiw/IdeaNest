# 🔥 АКТУАЛЬНІ FIREBASE RULES

## 📊 Firestore Database Rules

### Файл: `firestore.rules`

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection - each user can only access their own data
    match /users/{userId} {
      // Allow user to read and write their own profile
      allow read, write: if isOwner(userId);
      
      // Notes subcollection - user can CRUD their own notes
      match /notes/{noteId} {
        allow read: if isOwner(userId);
        allow create: if isOwner(userId);
        allow update: if isOwner(userId);
        allow delete: if isOwner(userId);
      }
      
      // Tags subcollection - user can CRUD their own tags
      match /tags/{tagId} {
        allow read: if isOwner(userId);
        allow create: if isOwner(userId);
        allow update: if isOwner(userId);
        allow delete: if isOwner(userId);
      }
    }
  }
}
```

### Як застосувати:

**Варіант 1 - Firebase Console (рекомендовано):**
1. Відкрийте: https://console.firebase.google.com/project/ideanest-2026/firestore/rules
2. Скопіюйте правила вище
3. Вставте в редактор
4. Натисніть **"Publish"**

**Варіант 2 - Firebase CLI:**
```bash
firebase deploy --only firestore:rules
```

### Що дозволяють ці правила:

✅ **Користувач може:**
- Читати свій профіль (`users/{userId}`)
- Оновлювати свій профіль (displayName, photoURL, etc.)
- Створювати/читати/оновлювати/видаляти свої нотатки
- Створювати/читати/оновлювати/видаляти свої теги

❌ **Користувач НЕ може:**
- Читати чужі профілі
- Читати чужі нотатки
- Читати чужі теги
- Взагалі доступатись до даних інших користувачів

### Структура даних:
```
users/
  {userId}/
    - displayName: string
    - email: string
    - photoURL: string (optional)
    - createdAt: timestamp
    - updatedAt: timestamp
    
    notes/
      {noteId}/
        - title: string
        - content: string
        - tagIds: array
        - createdAt: timestamp
        - updatedAt: timestamp
    
    tags/
      {tagId}/
        - name: string
        - color: number
```

---

## 📁 Firebase Storage Rules

### Файл: `storage.rules`

```javascript
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    
    // Profile photos - stored as: profile_photos/{userId}
    match /profile_photos/{userId} {
      
      // Anyone can read profile photos (public)
      allow read: if true;
      
      // Only authenticated user can upload their own photo
      // Validate: must be image, max 5MB
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.contentType.matches('image/.*')
                   && request.resource.size < 5 * 1024 * 1024;
      
      // Only owner can delete their photo
      allow delete: if request.auth != null 
                    && request.auth.uid == userId;
    }
  }
}
```

### Як застосувати:

**Варіант 1 - Firebase Console (рекомендовано):**
1. Відкрийте: https://console.firebase.google.com/project/ideanest-2026/storage/rules
2. Скопіюйте правила вище
3. Вставте в редактор
4. Натисніть **"Publish"**

**Варіант 2 - Firebase CLI:**
```bash
firebase deploy --only storage:rules
```

### Що дозволяють ці правила:

✅ **Будь-хто може:**
- Читати (переглядати) фото профілів

✅ **Авторизований користувач може:**
- Завантажити своє фото профілю
- Видалити своє фото профілю

❌ **Обмеження:**
- Тільки зображення (image/*)
- Максимум 5MB розмір
- Не можна завантажити фото для іншого користувача
- Не можна видалити чуже фото

### Структура Storage:
```
profile_photos/
  {userId}  ← Без розширення! Firebase сам додасть
```

**Приклад:** Користувач з ID `abc123` завантажує фото → збережеться як `profile_photos/abc123`

---

## 🔍 Важливі відмінності Storage Rules:

### ❌ НЕПРАВИЛЬНО:
```javascript
match /profile_photos/{userId}.jpg {  // НЕ ПРАЦЮЄ!
  allow write: if request.auth.uid == userId;
}
```

### ✅ ПРАВИЛЬНО:
```javascript
match /profile_photos/{userId} {  // БЕЗ розширення!
  allow write: if request.auth != null 
               && request.auth.uid == userId
               && request.resource.contentType.matches('image/.*');
}
```

**Чому БЕЗ `.jpg`?**
- Firebase Storage не підтримує розширення в `match` path
- Валідація типу файлу робиться через `contentType.matches('image/.*')`
- Це дозволяє завантажувати JPG, PNG, WebP, та інші формати зображень

---

## 📋 Швидкий чеклист:

### Firestore Database:
- [ ] Відкрито Firebase Console → Firestore → Rules
- [ ] Скопійовано правила з цього файлу
- [ ] Вставлено в редактор
- [ ] Натиснуто "Publish"
- [ ] Побачено "Rules published successfully"

### Firebase Storage:
- [ ] Відкрито Firebase Console → Storage → Rules
- [ ] Скопійовано правила з цього файлу
- [ ] Вставлено в редактор (БЕЗ `.jpg`!)
- [ ] Натиснуто "Publish"
- [ ] Побачено "Rules published successfully"

---

## 🧪 Як перевірити що правила працюють:

### Firestore:
1. Залогіньтесь в додаток
2. Створіть нотатку
3. Firebase Console → Firestore → Data
4. ✅ Має з'явитись: `users/{ваш UID}/notes/{noteId}`

### Storage:
1. Залогіньтесь в додаток
2. Settings → Завантажте фото
3. Firebase Console → Storage → Files
4. ✅ Має з'явитись: `profile_photos/{ваш UID}`

---

## 🚨 Можливі помилки:

### Firestore: "Missing or insufficient permissions"
**Причина:** Правила не опубліковані або неправильні

**Рішення:**
1. Перевірте що правила опубліковані
2. Перевірте що користувач залогінений
3. Перевірте структуру даних (`users/{userId}/notes/{noteId}`)

### Storage: "User does not have permission to access"
**Причина:** Правила не опубліковані або є `.jpg` у match

**Рішення:**
1. Видаліть `.jpg` з match path
2. Опублікуйте правила знову
3. Перевірте що користувач залогінений

### Storage: "File type not allowed"
**Причина:** Завантажується не зображення

**Рішення:**
- Правила дозволяють тільки `image/*`
- Виберіть файл зображення (JPG, PNG, WebP)

### Storage: "File too large"
**Причина:** Файл більше 5MB

**Рішення:**
- Виберіть менше фото
- Або збільште ліміт у правилах: `10 * 1024 * 1024` для 10MB

---

## ✅ Готово!

Скопіюйте ці правила в Firebase Console і опублікуйте.
Після цього всі функції додатку мають працювати правильно!

**Успіхів! 🚀**

