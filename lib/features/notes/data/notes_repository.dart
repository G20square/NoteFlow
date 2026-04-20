import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:note_flow/features/notes/data/local/hive_notes_datasource.dart';
import 'package:note_flow/features/notes/data/remote/firestore_notes_datasource.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';

class NotesRepository {
  final HiveNotesDatasource _local;
  final FirestoreNotesDatasource _remote;

  NotesRepository({
    required HiveNotesDatasource local,
    required FirestoreNotesDatasource remote,
  })  : _local = local,
        _remote = remote;

  // Real-time stream from Firestore, caches to Hive
  Stream<List<NoteModel>> watchNotes(String userId) {
    return _remote.watchNotes(userId).map((notes) {
      // Cache incoming Firestore data locally
      _local.upsertNotes(notes);
      return notes;
    });
  }

  // Offline-first: return from Hive if no connectivity
  Future<List<NoteModel>> getNotes(String userId) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        return _local.getAllNotes(userId);
      }
      final notes = await _remote.fetchNotes(userId);
      await _local.upsertNotes(notes);
      return notes;
    } catch (_) {
      return _local.getAllNotes(userId);
    }
  }

  // Offline-first write: Hive immediately, Firestore async
  Future<void> saveNote(NoteModel note) async {
    await _local.saveNote(note);
    _syncToFirestore(note);
  }

  Future<void> deleteNote(NoteModel note) async {
    await _local.deleteNote(note.id);
    _deleteFromFirestore(note.userId, note.id);
  }

  void _syncToFirestore(NoteModel note) {
    _remote.saveNote(note).catchError((e) {
      // Will re-sync on next connectivity
    });
  }

  void _deleteFromFirestore(String userId, String noteId) {
    _remote.deleteNote(userId, noteId).catchError((e) {
      // Silent - local delete is authoritative
    });
  }
}
