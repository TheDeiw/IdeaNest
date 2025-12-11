# CI/CD Setup Guide для IdeaNest

## Огляд

Цей документ описує налаштування CI/CD pipeline для автоматичної збірки та розгортання Android застосунку IdeaNest через **Bitrise** з використанням **Firebase App Distribution**.

## Архітектура

```
GitHub/GitLab Repository
         ↓
    Bitrise CI/CD
         ↓
   Flutter Build (APK)
         ↓
Firebase App Distribution
         ↓
    Тестери отримують APK
```

## Передумови

1. ✅ **Flutter проєкт** з налаштованим Firebase (вже є)
2. ✅ **google-services.json** для Android (вже є)
3. 🔲 **Bitrise аккаунт** (bitrise.io)
4. 🔲 **Firebase проєкт** з увімкненим App Distribution
5. 🔲 **Git репозиторій** (GitHub/GitLab/Bitbucket)

## Крок 1: Налаштування Firebase App Distribution

### 1.1 Увімкнути Firebase App Distribution

1. Відкрийте [Firebase Console](https://console.firebase.google.com/)
2. Виберіть проєкт **ideanest-2026**
3. У лівому меню знайдіть **Release & Monitor** → **App Distribution**
4. Клікніть **Get Started**

### 1.2 Отримати Firebase App ID

Ваш App ID для Android:
```
1:191269809993:android:62e07e81344fbb42157498
```

Це можна знайти в:
- Firebase Console → Project Settings → Your apps → Android app
- Або у файлі `android/app/google-services.json` → `mobilesdk_app_id`

### 1.3 Створити Firebase CLI Token

Вам потрібен CI token для автоматизації:

```bash
# Встановіть Firebase CLI (якщо ще не встановлено)
npm install -g firebase-tools

# Авторизуйтесь та згенеруйте CI token
firebase login:ci
```

**Збережіть отриманий token** - він знадобиться для Bitrise!

### 1.4 Додати тестерів

У Firebase Console → App Distribution:
1. Клікніть **Testers & Groups**
2. Додайте email адреси тестерів або створіть групу "testers"
3. Тестери отримають запрошення на email

## Крок 2: Налаштування Bitrise

### 2.1 Створити проєкт на Bitrise

1. Зайдіть на [bitrise.io](https://bitrise.io) та увійдіть
2. Клікніть **Add new app**
3. Виберіть ваш Git provider (GitHub/GitLab/Bitbucket)
4. Виберіть репозиторій з проєктом IdeaNest
5. Надайте доступ Bitrise до репозиторію

### 2.2 Налаштувати проєкт

1. **Project build configuration**:
   - Bitrise автоматично визначить, що це Flutter проєкт
   - Підтвердіть налаштування

2. **Choose app variant**:
   - Виберіть `android` як основну платформу

3. **Webhook setup**:
   - Дозвольте Bitrise автоматично налаштувати webhooks

### 2.3 Завантажити bitrise.yml

1. Перейдіть до вашого проєкту на Bitrise
2. Клікніть на **Workflows**
3. Перейдіть на вкладку **bitrise.yml**
4. Натисніть **Edit** та замініть вміст файлом `bitrise.yml` з репозиторію
5. Збережіть зміни

### 2.4 Додати Environment Variables (Secrets)

Перейдіть до **Workflow** → **Secrets**:

1. **FIREBASE_TOKEN**
   - Key: `FIREBASE_TOKEN`
   - Value: `<ваш token з команди firebase login:ci>`
   - ☑️ Expose for Pull Requests: NO
   - ☑️ Protected: YES

2. **FIREBASE_APP_ID**
   - Key: `FIREBASE_APP_ID`
   - Value: `1:191269809993:android:62e07e81344fbb42157498`
   - ☑️ Expose for Pull Requests: NO

### 2.5 (Опціонально) Налаштування підписування для production

Якщо ви хочете використовувати власний keystore (не debug):

1. Згенерувати keystore:
```bash
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

2. Завантажити keystore на Bitrise:
   - Workflow → Code Signing → Android keystore
   - Upload keystore file

3. Додати змінні:
   - `KEYSTORE_PASSWORD`: пароль keystore
   - `KEY_ALIAS`: alias ключа (наприклад, "key")
   - `KEY_PASSWORD`: пароль ключа
   - `KEYSTORE_FILE`: `$HOME/keystores/key.jks` (Bitrise автоматично розміщує тут)

## Крок 3: Запуск та тестування

### 3.1 Перший запуск

1. Зробіть commit та push до гілки `main`:
```bash
git add .
git commit -m "Add Bitrise CI/CD configuration"
git push origin main
```

2. Bitrise автоматично запустить workflow `deploy`

### 3.2 Перевірка процесу

У Bitrise Dashboard ви побачите:
1. ✅ Git Clone
2. ✅ Flutter Install
3. ✅ Cache Pull
4. ✅ Flutter pub get
5. ✅ Flutter test
6. ✅ Build Android APK
7. ✅ Firebase App Distribution
8. ✅ Deploy to Bitrise
9. ✅ Cache Push

### 3.3 Отримання APK

Після успішної збірки:
1. Тестери отримають email від Firebase App Distribution
2. APK також буде доступний у Bitrise → Build → Artifacts

## Workflows

### `test` workflow
Запускається автоматично на Pull Requests:
- Встановлює Flutter
- Запускає flutter analyze
- Запускає тести
- Кешує залежності

### `deploy` workflow
Запускається автоматично на push до `main`:
- Виконує всі кроки з `test`
- Будує APK
- Розгортає на Firebase App Distribution
- Зберігає артефакти

## Моніторинг та Налагодження

### Логи збірки
Всі логи доступні в Bitrise Dashboard для кожної збірки.

### Типові проблеми

1. **Firebase token invalid**
   - Перегенеруйте token: `firebase login:ci`
   - Оновіть в Bitrise Secrets

2. **Build failed - Gradle error**
   - Перевірте `android/build.gradle.kts`
   - Збільшіть heap memory: `GRADLE_OPTS`

3. **Tests failed**
   - Перевірте локально: `flutter test`
   - Виправте тести перед push

## Альтернативні варіанти

### Збірка AAB замість APK

Якщо ви плануєте публікацію в Google Play, розкоментуйте блок у `bitrise.yml`:

```yaml
# Uncomment this block and comment APK build block
- script@1:
    title: Build Android App Bundle (Release)
    inputs:
    - content: |
        flutter build appbundle --release
        cp build/app/outputs/bundle/release/app-release.aab $BITRISE_DEPLOY_DIR/
```

### Множинні середовища

Додайте окремі workflows для staging/production:

```yaml
workflows:
  deploy-staging:
    # Use staging Firebase project
  deploy-production:
    # Use production Firebase project
```

## Структура файлів

```
ideanest/
├── bitrise.yml                    # Конфігурація Bitrise CI/CD
├── android/
│   └── app/
│       ├── build.gradle.kts       # Оновлено: signing config
│       └── google-services.json   # Firebase config
├── lib/
│   └── firebase_options.dart      # Firebase options
└── CI_CD_SETUP.md                # Цей файл
```

## Корисні посилання

- [Bitrise Documentation](https://devcenter.bitrise.io/)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Firebase Console](https://console.firebase.google.com/)

## Інформація про проєкт

- **Project ID**: ideanest-2026
- **Android Package**: com.example.ideanest
- **Firebase App ID**: 1:191269809993:android:62e07e81344fbb42157498
- **Current Version**: 1.0.0+1

## Контакти

Для питань з налаштування зверніться до документації або команди розробки.

---

**Автор**: GitHub Copilot  
**Дата створення**: 11 грудня 2024  
**Версія**: 1.0

