import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/features/auth/presentation/providers/auth_provider.dart';
import 'package:note_flow/features/notes/data/local/hive_notes_datasource.dart';
import 'package:note_flow/features/notes/data/notes_repository.dart';
import 'package:note_flow/features/notes/data/remote/firestore_notes_datasource.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';

// Datasource providers
final hiveNotesDatasourceProvider = Provider<HiveNotesDatasource>((ref) {
  return HiveNotesDatasource();
});

final firestoreNotesDatasourceProvider = Provider<FirestoreNotesDatasource>((ref) {
  return FirestoreNotesDatasource();
});

// Repository
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(
    local: ref.watch(hiveNotesDatasourceProvider),
    remote: ref.watch(firestoreNotesDatasourceProvider),
  );
});

// Real-time notes stream
final notesStreamProvider = StreamProvider<List<NoteModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchNotes(user.uid);
});

// Filtered notes (not archived)
final activeNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  return ref.watch(notesStreamProvider).whenData(
      (notes) => notes.where((n) => !n.isArchived).toList());
});

// Pinned notes only
final pinnedNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  return ref.watch(activeNotesProvider).whenData(
      (notes) => notes.where((n) => n.isPinned).toList());
});

// Un-pinned, un-archived
final unpinnedNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  return ref.watch(activeNotesProvider).whenData(
      (notes) => notes.where((n) => !n.isPinned).toList());
});

// Archived notes
final archivedNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  return ref.watch(notesStreamProvider).whenData(
      (notes) => notes.where((n) => n.isArchived).toList());
});

// Notes Operations notifier
final notesActionsProvider = Provider<NotesActions>((ref) {
  return NotesActions(ref);
});

class NotesActions {
  final Ref _ref;
  NotesActions(this._ref);

  NotesRepository get _repo => _ref.read(notesRepositoryProvider);
  String? get _uid => _ref.read(currentUserProvider)?.uid;

  Future<void> saveNote(NoteModel note) async {
    final now = DateTime.now();
    final updated = note.copyWith(updatedAt: now);
    await _repo.saveNote(updated);
  }

  Future<void> deleteNote(NoteModel note) async {
    await _repo.deleteNote(note);
  }

  Future<void> togglePin(NoteModel note) async {
    await saveNote(note.copyWith(isPinned: !note.isPinned));
  }

  Future<void> toggleArchive(NoteModel note) async {
    await saveNote(note.copyWith(
      isArchived: !note.isArchived,
      isPinned: note.isArchived ? note.isPinned : false, // unpin when archiving
    ));
  }

  NoteModel newNote() {
    if (_uid == null) throw Exception('User not authenticated');
    return NoteModel.create(userId: _uid!);
  }
}
