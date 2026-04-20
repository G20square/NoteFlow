import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/theme/theme_provider.dart';
import 'package:note_flow/core/utils/date_utils.dart';
import 'package:note_flow/features/notes/domain/label_model.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';
import 'package:note_flow/features/notes/presentation/providers/notes_provider.dart';

class NoteCard extends ConsumerWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final bool isListMode;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.isListMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final noteColors = isDark ? AppColors.noteColorsDark : AppColors.noteColorsLight;
    final bgColor = noteColors[note.colorIndex.clamp(0, noteColors.length - 1)];
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showActionSheet(context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: isListMode
            ? const BoxConstraints(minHeight: 80)
            : const BoxConstraints(minHeight: 100, maxHeight: 220),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: note.title.isNotEmpty
                          ? Text(
                              note.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : const SizedBox.shrink(),
                    ),
                    if (note.isPinned)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.push_pin_rounded, size: 14, color: AppColors.primary),
                      ),
                  ],
                ),
                if (note.title.isNotEmpty && note.content.isNotEmpty)
                  const SizedBox(height: 6),
                // Content
                if (note.content.isNotEmpty)
                  Text(
                    note.content,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.5),
                    maxLines: isListMode ? 2 : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                // Labels
                if (note.labelIds.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: note.labelIds.take(2).map((id) {
                      final label = LabelModel.findById(id);
                      if (label == null) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: label.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: label.color.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(label.icon, size: 10, color: label.color),
                            const SizedBox(width: 4),
                            Text(label.name, style: TextStyle(fontSize: 10, color: label.color, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 8),
                // Date
                Text(
                  NoteDate.format(note.updatedAt),
                  style: theme.textTheme.labelMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final actions = ref.read(notesActionsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
                  color: AppColors.primary),
              title: Text(note.isPinned ? 'Unpin note' : 'Pin note'),
              onTap: () {
                Navigator.pop(ctx);
                actions.togglePin(note);
              },
            ),
            ListTile(
              leading: Icon(note.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
              title: Text(note.isArchived ? 'Unarchive' : 'Archive'),
              onTap: () {
                Navigator.pop(ctx);
                actions.toggleArchive(note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete note', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(notesActionsProvider).deleteNote(note);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
