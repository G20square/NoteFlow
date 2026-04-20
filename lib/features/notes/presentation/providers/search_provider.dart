import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';
import 'package:note_flow/features/notes/presentation/providers/notes_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<NoteModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final notesAsync = ref.watch(notesStreamProvider);

  if (query.isEmpty) return [];

  return notesAsync.when(
    data: (notes) => notes
        .where((n) =>
            !n.isArchived &&
            (n.title.toLowerCase().contains(query) ||
                n.content.toLowerCase().contains(query)))
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Filter by label
final selectedLabelIdProvider = StateProvider<String?>((ref) => null);

final labelFilteredNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  final labelId = ref.watch(selectedLabelIdProvider);
  if (labelId == null) return ref.watch(activeNotesProvider);

  return ref.watch(activeNotesProvider).whenData(
      (notes) => notes.where((n) => n.labelIds.contains(labelId)).toList());
});
