import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_flow/features/notes/data/local/note_hive_model.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';

const String _notesBoxName = 'notes';

class HiveNotesDatasource {
  Box<NoteHiveModel> get _box => Hive.box<NoteHiveModel>(_notesBoxName);

  static Future<void> init() async {
    Hive.registerAdapter(NoteHiveModelAdapter());
    await Hive.openBox<NoteHiveModel>(_notesBoxName);
  }

  List<NoteModel> getAllNotes(String userId) {
    return _box.values
        .where((n) => n.userId == userId)
        .map((n) => n.toDomain())
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  NoteModel? getNoteById(String id) {
    final hive = _box.get(id);
    return hive?.toDomain();
  }

  Future<void> saveNote(NoteModel note) async {
    final hiveNote = NoteHiveModel.fromDomain(note);
    await _box.put(note.id, hiveNote);
  }

  Future<void> deleteNote(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAllForUser(String userId) async {
    final keys = _box.values
        .where((n) => n.userId == userId)
        .map((n) => n.id)
        .toList();
    await _box.deleteAll(keys);
  }

  Future<void> upsertNotes(List<NoteModel> notes) async {
    final map = {for (final n in notes) n.id: NoteHiveModel.fromDomain(n)};
    await _box.putAll(map);
  }
}
