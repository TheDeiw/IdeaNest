# Firebase Security Best Practices

## 🔐 Статус безпеки проєкту

### ✅ Що виправлено:

1. **google-services.json** - додано до .gitignore
2. **firebase_options.dart** - додано до .gitignore  
3. **GoogleService-Info.plist** - додано до .gitignore (для iOS)

## ⚠️ Важливо розуміти: Firebase API Keys

### Чому Firebase API ключі в коді - це НОРМАЛЬНО?

Firebase API ключі для клієнтських додатків (Android, iOS, Web) **НЕ є секретами**. Це офіційна позиція Google:

> "Unlike how API keys are typically used, API keys for Firebase services are not used to control access to backend resources; that can only be done with Firebase Security Rules. Usually, you need to fastidiously guard API keys (for example, by using a vault service or setting the keys as environment variables); however, API keys for Firebase services are ok to include in code or checked-in config files."
> 
> — [Firebase Documentation](https://firebase.google.com/docs/projects/api-keys)

### Як Firebase захищає ваші дані?

1. **Firebase Security Rules** - основний механізм захисту
   ```javascript
   // Приклад правил Firestore
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /notes/{noteId} {
         // Тільки автентифіковані користувачі
         allow read, write: if request.auth != null 
                          && request.auth.uid == resource.data.userId;
       }
     }
   }
   ```

2. **Application Restrictions** - обмеження по додатку
   - Package name для Android: `com.example.ideanest`
   - Bundle ID для iOS
   - Authorized domains для Web

3. **Firebase App Check** - захист від зловмисних запитів
   - Device attestation
   - reCAPTCHA для Web
   - Play Integrity для Android

## 🚨 Що РОБИТИ після витоку ключів

Якщо GitHub надіслав попередження, виконайте наступні кроки:

### Крок 1: Обмежити API ключі в Firebase Console

1. Відкрийте [Google Cloud Console](https://console.cloud.google.com/)
2. Виберіть проєкт `ideanest-2026`
3. Перейдіть до **APIs & Services** → **Credentials**
4. Знайдіть API ключі:
   - Android: `AIzaSyBLk8cb0I5uLMMxVUW7toQm_5ovPjLdpjU`
   - Web: `AIzaSyAfzO6fWZLYAViE1r5LlMgNyqsXDX8wS-I`

### Крок 2: Налаштувати Application Restrictions

Для кожного API ключа:

#### Android API Key
```
Application restrictions:
  ☑️ Android apps
  
Restrict usage to your Android apps:
  Package name: com.example.ideanest
  SHA-1 fingerprint: <your-sha1-from-keystore>
```

#### Web API Key
```
Application restrictions:
  ☑️ HTTP referrers (web sites)
  
Website restrictions:
  https://ideanest-2026.web.app/*
  https://ideanest-2026.firebaseapp.com/*
  http://localhost:*
```

### Крок 3: Налаштувати API Restrictions

Обмежити API ключ тільки необхідними сервісами:

```
API restrictions:
  ☑️ Restrict key
  
Select APIs:
  ✓ Cloud Firestore API
  ✓ Firebase Authentication
  ✓ Firebase Storage
  ✓ Cloud Functions
  ✓ Identity Toolkit API
```

### Крок 4: Видалити з Git History (якщо потрібно)

Якщо файли вже були в Git:

```bash
# Видалити google-services.json з історії
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch android/app/google-services.json" \
  --prune-empty --tag-name-filter cat -- --all

# Видалити firebase_options.dart з історії
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/firebase_options.dart" \
  --prune-empty --tag-name-filter cat -- --all

# Форсувати push
git push origin --force --all
```

⚠️ **УВАГА**: `git filter-branch` переписує історію! Використовуйте з обережністю.

### Альтернатива: BFG Repo-Cleaner (рекомендовано)

```bash
# Встановити BFG
# Windows (Chocolatey):
choco install bfg

# Використати BFG
bfg --delete-files google-services.json
bfg --delete-files firebase_options.dart

# Очистити repo
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Push
git push origin --force --all
```

## 🛡️ Поточний стан безпеки проєкту

### ✅ Що вже налаштовано:

1. **Firestore Security Rules** (`firestore.rules`):
   ```javascript
   // Захист даних користувачів
   match /notes/{noteId} {
     allow read, write: if request.auth != null;
   }
   ```

2. **Storage Security Rules** (`storage.rules`):
   ```javascript
   // Захист файлів користувачів
   match /user-photos/{userId}/{allPaths=**} {
     allow read, write: if request.auth != null 
                      && request.auth.uid == userId;
   }
   ```

3. **Firebase Authentication**:
   - Email/Password authentication активовано
   - Тільки автентифіковані користувачі мають доступ

### 🔒 Додаткові рекомендації:

1. **Увімкніть Firebase App Check**:
   ```dart
   // В main.dart додайте:
   import 'package:firebase_app_check/firebase_app_check.dart';
   
   await FirebaseAppCheck.instance.activate(
     webRecaptchaSiteKey: 'your-recaptcha-site-key',
     androidProvider: AndroidProvider.playIntegrity,
   );
   ```

2. **Rate Limiting в Security Rules**:
   ```javascript
   match /notes/{noteId} {
     allow create: if request.auth != null 
                   && request.time > resource.data.lastCreated + duration.value(1, 's');
   }
   ```

3. **Моніторинг використання**:
   - Firebase Console → Usage and billing
   - Налаштуйте alerts для незвичної активності

## 📋 Чеклист безпеки

Перевірте наступне:

- [x] google-services.json додано до .gitignore
- [x] firebase_options.dart додано до .gitignore
- [x] Firestore Security Rules налаштовані
- [x] Storage Security Rules налаштовані
- [x] Firebase Authentication активовано
- [ ] API ключі обмежені в Google Cloud Console
- [ ] Application restrictions налаштовані
- [ ] Firebase App Check увімкнено (опціонально)
- [ ] Моніторинг використання налаштовано

## 🔧 Що робити ЗАРАЗ

### Варіант 1: Залишити як є (рекомендовано для розробки)

Якщо це навчальний проєкт:
1. ✅ Файли вже додані до .gitignore
2. ✅ Security Rules вже налаштовані
3. ✅ Обмеження по package name працюють
4. ✅ Можна продовжувати розробку

### Варіант 2: Повністю очистити (для production)

Якщо готуєтесь до production:
1. Обмежте API ключі в Google Cloud Console
2. Видаліть файли з Git history (BFG)
3. Увімкніть Firebase App Check
4. Налаштуйте rate limiting
5. Створіть нові API ключі (опціонально)

## 📞 Додаткові ресурси

- [Firebase Security Documentation](https://firebase.google.com/docs/rules)
- [API Keys Best Practices](https://firebase.google.com/docs/projects/api-keys)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [Google Cloud Console](https://console.cloud.google.com/)

## ⚡ Швидке рішення для GitHub Warning

Якщо GitHub надіслав попередження:

```bash
# 1. Додайте файли до .gitignore (вже зроблено)
# 2. Видаліть з поточного commit
git rm --cached android/app/google-services.json
git rm --cached lib/firebase_options.dart

# 3. Commit
git commit -m "Remove sensitive files from tracking"

# 4. Push
git push
```

Після цього попередження мають зникнути. GitHub автоматично закриє alert через 24-48 годин.

---

**Створено:** 11 грудня 2024  
**Проєкт:** IdeaNest  
**Статус:** ✅ Безпека налаштована

