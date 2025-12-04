# Quick Reference - Використання Firestore Providers в UI

## Імпорти

```dart
// В файлах де використовуєте providers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideanest/src/features/notes/application/notes_provider.dart';
import 'package:ideanest/src/features/tags/application/tags_provider.dart';
import 'package:ideanest/src/features/settings/application/user_profile_provider.dart';
import 'package:ideanest/src/features/notes/domain/note.dart';
import 'package:ideanest/src/features/tags/domain/tag.dart';
```

## Notes Provider - Приклади використання

### 1. Відобразити список заміток

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    
    return notesAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (notes) => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(note: note);
        },
      ),
    );
  }
}
```

### 2. Створити нову замітку

```dart
Future<void> _createNote() async {
  final notifier = ref.read(notesProvider.notifier);
  
  final note = await notifier.createNote(
    title: _titleController.text,
    content: _contentController.text,
    tagIds: _selectedTagIds,
    isPinned: false,
  );
  
  if (note != null) {
    Navigator.pop(context);
  }
}
```

### 3. Оновити замітку

```dart
Future<void> _updateNote(Note note) async {
  final notifier = ref.read(notesProvider.notifier);
  
  await notifier.updateNote(note.copyWith(
    title: _titleController.text,
    content: _contentController.text,
    tagIds: _selectedTagIds,
  ));
  
  Navigator.pop(context);
}
```

### 4. Видалити замітку

```dart
Future<void> _deleteNote(String noteId) async {
  final notifier = ref.read(notesProvider.notifier);
  await notifier.deleteNote(noteId);
}
```

### 5. Пошук заміток

```dart
Future<void> _searchNotes(String query) async {
  final notifier = ref.read(notesProvider.notifier);
  final results = await notifier.searchNotes(query);
  setState(() {
    _searchResults = results;
  });
}
```

### 6. Фільтрація по тегах (використовуйте filteredNotesProvider)

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Використовуємо filteredNotesProvider замість notesProvider
    final filteredNotesAsync = ref.watch(filteredNotesProvider);
    
    return filteredNotesAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
      data: (notes) => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => NoteCard(note: notes[index]),
      ),
    );
  }
}

// Встановити фільтри
void _setFilters() {
  // Встановити пошуковий запит
  ref.read(searchQueryProvider.notifier).updateQuery('my search');
  
  // Встановити теги для фільтрації
  ref.read(selectedFilterTagsProvider.notifier).toggleTag('tag-id');
}
```

### 7. Закріплені замітки

```dart
class PinnedNotesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(pinnedNotesProvider);
    
    return pinnedAsync.when(
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
      data: (pinnedNotes) {
        if (pinnedNotes.isEmpty) return SizedBox.shrink();
        
        return Column(
          children: pinnedNotes.map((note) => NoteCard(note: note)).toList(),
        );
      },
    );
  }
}
```

## Tags Provider - Приклади використання

### 1. Відобразити список тегів

```dart
class TagsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);
    
    return tagsAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (tags) => Wrap(
        spacing: 8,
        children: tags.map((tag) => Chip(
          label: Text(tag.name),
          backgroundColor: Color(tag.color),
        )).toList(),
      ),
    );
  }
}
```

### 2. Додати новий тег

```dart
Future<void> _addTag() async {
  final notifier = ref.read(tagsProvider.notifier);
  
  await notifier.addTag(
    _tagNameController.text,
    _selectedColor,
  );
}
```

### 3. Оновити тег

```dart
Future<void> _updateTag(Tag tag) async {
  final notifier = ref.read(tagsProvider.notifier);
  
  await notifier.updateTag(tag.copyWith(
    name: _newName,
    color: _newColor,
  ));
}
```

### 4. Видалити тег

```dart
Future<void> _deleteTag(String tagId) async {
  final notifier = ref.read(tagsProvider.notifier);
  await notifier.removeTag(tagId);
}
```

### 5. Пошук тега за назвою

```dart
Tag? findTag(String name) {
  final notifier = ref.read(tagsProvider.notifier);
  return notifier.findTagByName(name);
}
```

### 6. Отримати тег за ID

```dart
Tag? getTag(String id) {
  final notifier = ref.read(tagsProvider.notifier);
  return notifier.getTagById(id);
}
```

## User Profile Provider - Приклади використання

### 1. Відобразити профіль користувача

```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    
    return profileAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (profile) {
        if (profile == null) return Text('No profile');
        
        return Column(
          children: [
            Text('Name: ${profile.displayName}'),
            Text('Email: ${profile.email}'),
            if (profile.photoURL != null)
              CircleAvatar(backgroundImage: NetworkImage(profile.photoURL!)),
          ],
        );
      },
    );
  }
}
```

### 2. Оновити ім'я користувача

```dart
Future<void> _updateDisplayName() async {
  final notifier = ref.read(userProfileProvider.notifier);
  await notifier.updateDisplayName(_nameController.text);
}
```

### 3. Оновити фото профілю

```dart
Future<void> _updatePhoto(String photoUrl) async {
  final notifier = ref.read(userProfileProvider.notifier);
  await notifier.updatePhotoURL(photoUrl);
}
```

## Обробка помилок

### Показати SnackBar при помилці

```dart
class NoteEditScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  @override
  void initState() {
    super.initState();
    
    // Listen to errors
    ref.listenManual(notesProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
      );
    });
  }
  
  // ... rest of code
}
```

## Loading States

### Показати індикатор завантаження

```dart
class SaveButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final isLoading = notesAsync.isLoading;
    
    return ElevatedButton(
      onPressed: isLoading ? null : _saveNote,
      child: isLoading 
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text('Save'),
    );
  }
}
```

## Refresh Data

### Оновити дані з Firestore

```dart
Future<void> _refreshData() async {
  // Refresh notes
  await ref.read(notesProvider.notifier).refresh();
  
  // Refresh tags
  await ref.read(tagsProvider.notifier).refresh();
  
  // Refresh profile
  await ref.read(userProfileProvider.notifier).refresh();
}

// Використання з RefreshIndicator
RefreshIndicator(
  onRefresh: _refreshData,
  child: ListView(...),
)
```

## Приклад повного екрану редагування

```dart
class NoteEditScreen extends ConsumerStatefulWidget {
  final String? noteId;
  
  const NoteEditScreen({this.noteId});
  
  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<String> _selectedTagIds = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    
    if (widget.noteId != null) {
      _loadNote();
    }
  }
  
  Future<void> _loadNote() async {
    final note = await ref.read(notesProvider.notifier).getNote(widget.noteId!);
    if (note != null) {
      setState(() {
        _titleController.text = note.title;
        _contentController.text = note.content;
        _selectedTagIds = note.tagIds;
      });
    }
  }
  
  Future<void> _saveNote() async {
    setState(() => _isLoading = true);
    
    try {
      final notifier = ref.read(notesProvider.notifier);
      
      if (widget.noteId != null) {
        // Update existing note
        final note = await notifier.getNote(widget.noteId!);
        if (note != null) {
          await notifier.updateNote(note.copyWith(
            title: _titleController.text,
            content: _contentController.text,
            tagIds: _selectedTagIds,
          ));
        }
      } else {
        // Create new note
        await notifier.createNote(
          title: _titleController.text,
          content: _contentController.text,
          tagIds: _selectedTagIds,
        );
      }
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId != null ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: _isLoading 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
              : Icon(Icons.save),
            onPressed: _isLoading ? null : _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
            maxLines: 10,
          ),
          tagsAsync.when(
            loading: () => CircularProgressIndicator(),
            error: (err, _) => Text('Error loading tags'),
            data: (tags) => Wrap(
              spacing: 8,
              children: tags.map((tag) => FilterChip(
                label: Text(tag.name),
                selected: _selectedTagIds.contains(tag.id),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTagIds.add(tag.id);
                    } else {
                      _selectedTagIds.remove(tag.id);
                    }
                  });
                },
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
```

## Важливі нотатки

1. **AsyncNotifier завжди повертає AsyncValue** - використовуйте `.when()`, `.whenData()`, або `.whenOrNull()`
2. **ref.watch vs ref.read:**
   - `ref.watch()` - підписується на зміни, перебудовує widget
   - `ref.read()` - одноразове читання, використовується в методах/callbacks
3. **Завжди перевіряйте mounted** перед операціями після async
4. **Обробляйте помилки** - Firestore може викидати різні exceptions
5. **Loading states** - показуйте користувачу що відбувається

