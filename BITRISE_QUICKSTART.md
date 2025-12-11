# Bitrise CI/CD - Швидкий старт

## Чеклист налаштування

### 📋 Перед початком
- [ ] Маєте аккаунт на [bitrise.io](https://bitrise.io)
- [ ] Маєте доступ до [Firebase Console](https://console.firebase.google.com/)
- [ ] Код завантажено в Git репозиторій (GitHub/GitLab/Bitbucket)

### 🔥 Firebase App Distribution

1. **Увімкнути App Distribution**
   - [ ] Відкрити Firebase Console → ideanest-2026
   - [ ] Release & Monitor → App Distribution → Get Started
   
2. **Отримати Firebase Token**
   ```bash
   npm install -g firebase-tools
   firebase login:ci
   ```
   - [ ] Скопіювати та зберегти token

3. **Додати тестерів**
   - [ ] App Distribution → Testers & Groups
   - [ ] Створити групу "testers"
   - [ ] Додати email адреси

### 🚀 Bitrise налаштування

1. **Створити проєкт**
   - [ ] Зайти на bitrise.io
   - [ ] Add new app
   - [ ] Підключити Git репозиторій
   - [ ] Вибрати Flutter/Android

2. **Завантажити конфігурацію**
   - [ ] Workflows → bitrise.yml → Edit
   - [ ] Вставити вміст з файлу `bitrise.yml`
   - [ ] Save

3. **Додати Secrets** (Workflow → Secrets)
   - [ ] `FIREBASE_TOKEN` = `<ваш token>`
   - [ ] `FIREBASE_APP_ID` = `1:191269809993:android:62e07e81344fbb42157498`

### ✅ Тестування

1. **Перший Deploy**
   ```bash
   git add .
   git commit -m "Setup Bitrise CI/CD"
   git push origin main
   ```

2. **Перевірка**
   - [ ] Відкрити Bitrise Dashboard
   - [ ] Дочекатись завершення збірки
   - [ ] Перевірити всі кроки (зелені ✓)
   - [ ] Переглянути Artifacts

3. **Перевірка Firebase**
   - [ ] Відкрити Firebase Console → App Distribution
   - [ ] Побачити новий release
   - [ ] Тестери отримали email

## Змінні середовища

| Змінна | Значення | Обов'язкова |
|--------|----------|-------------|
| `FIREBASE_TOKEN` | Token з `firebase login:ci` | ✅ Так |
| `FIREBASE_APP_ID` | `1:191269809993:android:62e07e81344fbb42157498` | ✅ Так |
| `KEYSTORE_PASSWORD` | Пароль keystore | ⚪ Ні (опціонально) |
| `KEY_ALIAS` | Alias ключа | ⚪ Ні (опціонально) |
| `KEY_PASSWORD` | Пароль ключа | ⚪ Ні (опціонально) |

## Workflows

### Автоматичні тригери

- **Push to `main`** → Запускає `deploy` workflow
  - Будує APK
  - Деплоїть на Firebase App Distribution
  
- **Pull Request** → Запускає `test` workflow
  - Перевіряє код
  - Запускає тести

### Ручний запуск

У Bitrise можна запустити будь-який workflow вручну:
1. Dashboard → Start/Schedule a build
2. Вибрати workflow
3. Вибрати гілку
4. Start build

## Корисні команди

### Firebase CLI
```bash
# Авторизація
firebase login

# CI Token
firebase login:ci

# Перевірка проєктів
firebase projects:list

# Деплой вручну (для тесту)
firebase appdistribution:distribute app-release.apk \
  --app 1:191269809993:android:62e07e81344fbb42157498 \
  --groups "testers"
```

### Flutter Build локально
```bash
# Встановити залежності
flutter pub get

# Запустити тести
flutter test

# Зібрати APK
flutter build apk --release

# Зібрати AAB
flutter build appbundle --release
```

## Перевірка файлів

Переконайтесь, що ці файли існують:

- [x] `bitrise.yml` - конфігурація Bitrise
- [x] `android/app/build.gradle.kts` - оновлено signing config
- [x] `android/app/google-services.json` - Firebase config
- [x] `lib/firebase_options.dart` - Firebase options
- [x] `CI_CD_SETUP.md` - детальна документація
- [x] `BITRISE_QUICKSTART.md` - цей файл

## Troubleshooting

### ❌ Build failed

**Помилка**: "No matching variant found for :app"
```bash
# Очистити кеш
flutter clean
flutter pub get
```

**Помилка**: "Firebase token invalid"
```bash
# Перегенерувати token
firebase login:ci
# Оновити в Bitrise Secrets
```

**Помилка**: "Tests failed"
```bash
# Запустити локально
flutter test --no-sound-null-safety
# Виправити тести
```

### 🐢 Повільна збірка

Bitrise кешує залежності автоматично. Якщо збірка все одно повільна:
1. Перевірте, чи працює `cache-push` та `cache-pull`
2. Розгляньте Premium plan з більш потужними машинами

### 📧 Тестери не отримують email

1. Перевірте, чи додані в Firebase Console
2. Перевірте spam папку
3. Перевірте `groups: "testers"` у bitrise.yml відповідає назві групи

## Наступні кроки

- [ ] Налаштувати окремі workflows для staging/production
- [ ] Додати автоматичне версіонування
- [ ] Інтегрувати з Slack для сповіщень
- [ ] Додати performance тести
- [ ] Налаштувати збірку для iOS (якщо потрібно)

## Підтримка

- 📖 [Детальна документація](./CI_CD_SETUP.md)
- 🔗 [Bitrise Docs](https://devcenter.bitrise.io/)
- 🔥 [Firebase App Distribution Docs](https://firebase.google.com/docs/app-distribution)

---

**Успішних деплоїв! 🚀**

