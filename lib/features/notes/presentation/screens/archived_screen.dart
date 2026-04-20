import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:note_flow/core/constants/app_strings.dart';
import 'package:note_flow/features/notes/presentation/providers/notes_provider.dart';
import 'package:note_flow/features/notes/presentation/widgets/empty_state.dart';
import 'package:note_flow/features/notes/presentation/widgets/note_card.dart';

class ArchivedScreen extends ConsumerWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedAsync = ref.watch(archivedNotesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.archived)),
      body: archivedAsync.when(
        data: (notes) => notes.isEmpty
            ? const EmptyState(
                icon: Icons.archive_outlined,
                title: 'No archived notes',
                subtitle: 'Notes you archive will appear here',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: notes.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NoteCard(
                    note: notes[index],
                    isListMode: true,
                    onTap: () => context.pushNamed('editor', extra: notes[index]),
                  ).animate(delay: (index * 40).ms).fadeIn().slideY(begin: 0.2, end: 0),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
