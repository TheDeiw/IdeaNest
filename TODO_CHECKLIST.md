# 📋 Чеклист наступних дій

## ✅ Що вже зроблено

- [x] Встановлено `cloud_firestore: ^6.1.0`
- [x] Створено domain models (Note, Tag, UserProfile)
- [x] Створено repositories (NotesRepository, TagsRepository, UserProfileRepository)
- [x] Створено providers (notesProvider, tagsProvider, userProfileProvider)
- [x] Оновлено tagsProvider на AsyncNotifier
- [x] Створено документацію (3 файли)
- [x] Підготовлено Security Rules

## 🔲 Що потрібно зробити зараз

### 1. Налаштування Firebase Console (15 хв)

- [ ] Відкрити [Firebase Console](https://console.firebase.google.com)
- [ ] Build → Firestore Database → Create database
- [ ] Вибрати "Start in test mode"
- [ ] Вибрати регіон `europe-west1`
- [ ] Створити тестові дані:
  - [ ] Колекція `users`
  - [ ] Документ з вашим Firebase Auth UID
  - [ ] Підколекція `notes` з 1-2 тестовими замітками
  - [ ] Підколекція `tags` з 2-3 тестовими тегами
- [ ] **Зробити скріншот структури даних** 📸
- [ ] Перейти на вкладку Rules
- [ ] Скопіювати rules з `FIREBASE_SETUP_GUIDE.md`
- [ ] Publish rules
- [ ] **Зробити скріншот Rules** 📸

**Довідка:** детальні інструкції в `FIREBASE_SETUP_GUIDE.md`

### 2. Оновлення main.dart (2 хв)

Відкрити `lib/main.dart` і додати:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Увімкнути offline persistence (опціонально)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### 3. Оновлення Add Tag Dialog (5 хв)

**Файл:** `lib/src/features/tags/presentation/widgets/add_tag_dialog.dart`

Знайти рядок ~72 і замінити:
```dart
// Було:
ref.read(tagsProvider.notifier).addTag(tag);

// Стане:
await ref.read(tagsProvider.notifier).addTag(tag.name, tag.color);
```

Також додати обробку AsyncValue:
```dart
final tagsAsync = ref.watch(tagsProvider);

tagsAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text('Error: $err'),
  data: (tags) => ListView(children: tags.map(...).toList()),
)
```

### 4. Оновлення Home Screen (10 хв)

**Файл:** `lib/src/features/notes/presentation/screens/home_screen.dart`

Додати імпорт:
```dart
import 'package:ideanest/src/features/notes/application/filtered_notes_provider.dart';
```

Замінити в `build()`:
```dart
// Замість захардкодженого списку NoteCard():
final notesAsync = ref.watch(filteredNotesProvider);

return notesAsync.when(
  loading: () => Center(child: CircularProgressIndicator()),
  error: (err, _) => Center(child: Text('Error: $err')),
  data: (notes) {
    if (notes.isEmpty) {
      return Center(child: Text('No notes yet'));
    }
    
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(note: note); // Потрібно оновити NoteCard
      },
    );
  },
);
```

### 5. Оновлення Note Card (5 хв)

**Файл:** `lib/src/features/notes/presentation/widgets/note_card.dart`

Додати параметр до конструктора:
```dart
class NoteCard extends StatelessWidget {
  final Note note;
  
  const NoteCard({super.key, required this.note});
  
  @override
  Widget build(BuildContext context) {
    // Використовувати note.title, note.content, note.tagIds
  }
}
```

### 6. Оновлення Note Edit Screen (15 хв)

**Файл:** `lib/src/features/notes/presentation/screens/note_edit_screen.dart`

Додати імпорт:
```dart
import 'package:ideanest/src/features/notes/application/notes_provider.dart';
```

Додати метод збереження:
```dart
Future<void> _saveNote() async {
  final notifier = ref.read(notesProvider.notifier);
  
  if (widget.noteId != null) {
    // Оновлення існуючої
    final note = await notifier.getNote(widget.noteId!);
    if (note != null) {
      await notifier.updateNote(note.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        tagIds: _selectedTagIds,
      ));
    }
  } else {
    // Створення нової
    await notifier.createNote(
      title: _titleController.text,
      content: _contentController.text,
      tagIds: _selectedTagIds,
    );
  }
  
  if (mounted) Navigator.pop(context);
}
```

Замінити в AppBar actions іконку save:
```dart
IconButton(
  icon: const Icon(Icons.save),
  onPressed: _saveNote,
),
```

### 7. Оновлення Settings Screen (10 хв)

**Файл:** `lib/src/features/settings/presentation/screens/settings_screen.dart`

Додати імпорт:
```dart
import 'package:ideanest/src/features/settings/application/user_profile_provider.dart';
```

Змінити на ConsumerWidget і використати provider:
```dart
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    
    return profileAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error: $err'),
      data: (profile) {
        final displayName = profile?.displayName ?? 'User';
        final email = profile?.email ?? '';
        
        // Використовувати displayName та email в UI
        return Scaffold(...);
      },
    );
  }
}
```

Додати метод оновлення імені:
```dart
Future<void> _updateName(WidgetRef ref, String newName) async {
  await ref.read(userProfileProvider.notifier).updateDisplayName(newName);
}
```

### 8. Тестування (10 хв)

- [ ] Запустити додаток: `flutter run`
- [ ] Перевірити автентифікацію
- [ ] Створити нову замітку
- [ ] Відредагувати замітку
- [ ] Видалити замітку
- [ ] Додати тег
- [ ] Змінити ім'я в Settings
- [ ] Перевірити пошук
- [ ] Перевірити фільтрацію по тегах

### 9. Для звіту (10 хв)

- [ ] **Скріншот Firebase Console - Data** з прикладами документів
- [ ] **Скріншот Firebase Console - Rules**
- [ ] **Скріншот Firebase Console - Indexes** (якщо є)
- [ ] **Таблиця опису полів** (взяти з FIREBASE_SETUP_GUIDE.md)
- [ ] **Код Security Rules** з поясненням
- [ ] **Фрагменти коду:**
  - [ ] Note model
  - [ ] NotesRepository
  - [ ] notesProvider
- [ ] **Скріншоти роботи додатку:**
  - [ ] Список заміток
  - [ ] Створення/редагування
  - [ ] Settings з профілем

## 🐛 Виправлення помилок

Якщо виникнуть помилки компіляції в існуючих файлах:

### search_screen.dart
Проблема: використання старого API tagsProvider

Рішення:
```dart
final tagsAsync = ref.watch(tagsProvider);

tagsAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text('Error'),
  data: (tags) => /* ваш UI */,
)
```

### add_tag_dialog.dart
Проблема: неправильний виклик addTag

Рішення:
```dart
await ref.read(tagsProvider.notifier).addTag(tagName, colorValue);
```

## 📚 Довідка

- **Приклади коду:** `USAGE_GUIDE.md`
- **Налаштування Firebase:** `FIREBASE_SETUP_GUIDE.md`
- **Технічні деталі:** `IMPLEMENTATION_SUMMARY.md`
- **Загальний огляд:** `COMPLETION_SUMMARY.md`

## ⏱️ Загальний час: ~1.5 години

- Firebase Console: 15 хв
- main.dart: 2 хв
- Add Tag Dialog: 5 хв
- Home Screen: 10 хв
- Note Card: 5 хв
- Note Edit Screen: 15 хв
- Settings Screen: 10 хв
- Тестування: 10 хв
- Звіт: 10 хв

## 🎯 Пріоритет завдань

1. **Високий (зробити зараз):**
   - ✅ Налаштувати Firebase Console
   - ✅ Оновити main.dart
   - ✅ Виправити add_tag_dialog.dart

2. **Середній (для функціоналу):**
   - ⚠️ Оновити home_screen.dart
   - ⚠️ Оновити note_edit_screen.dart
   - ⚠️ Оновити note_card.dart

3. **Низький (додатково):**
   - 🔵 Оновити settings_screen.dart
   - 🔵 Виправити search_screen.dart

## ✅ Готово до здачі коли:

- [x] Firestore налаштовано в консолі
- [x] Security Rules встановлено
- [x] Додаток компілюється без помилок
- [x] CRUD операції працюють
- [x] Зроблено скріншоти
- [x] Підготовлено код для звіту

---

**Успіхів! 🚀**

