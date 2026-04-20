import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/constants/app_strings.dart';
import 'package:note_flow/features/notes/domain/label_model.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';
import 'package:note_flow/features/notes/presentation/providers/notes_provider.dart';
import 'package:note_flow/features/notes/presentation/providers/search_provider.dart';
import 'package:note_flow/features/notes/presentation/widgets/empty_state.dart';
import 'package:note_flow/features/notes/presentation/widgets/labels_chip_bar.dart';
import 'package:note_flow/features/notes/presentation/widgets/note_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final pinnedAsync = ref.watch(pinnedNotesProvider);
    final unpinnedAsync = ref.watch(labelFilteredNotesProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            title: const Text(AppStrings.myNotes),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search',
                onPressed: () => context.pushNamed('search'),
              ),
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
                tooltip: _isGridView ? 'List view' : 'Grid view',
                onPressed: () => setState(() => _isGridView = !_isGridView),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => _showMenu(context),
              ),
            ],
          ),
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const LabelsChipBar()),
            // Pinned section
            pinnedAsync.when(
              data: (pinned) {
                if (pinned.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(AppStrings.pinned, Icons.push_pin_rounded),
                      _buildNoteGrid(pinned, context),
                      _sectionHeader(AppStrings.others, null),
                    ],
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
            // Main notes
            unpinnedAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  final pinnedNotes = ref.watch(pinnedNotesProvider).value ?? [];
                  if (pinnedNotes.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyState(
                        icon: Icons.note_alt_outlined,
                        title: AppStrings.noNotes,
                        subtitle: AppStrings.noNotesSubtitle,
                      ),
                    );
                  }
                }
                return _isGridView
                    ? _buildSliverGrid(notes)
                    : _buildSliverList(notes);
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: CircularProgressIndicator(),
                )),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),
            // Bottom padding for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNote,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note'),
        heroTag: 'fab_home',
      ).animate().scale(delay: 300.ms, curve: Curves.elasticOut),
    );
  }

  Widget _sectionHeader(String title, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
          ],
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteGrid(List<NoteModel> notes, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: notes.length,
        itemBuilder: (_, index) => NoteCard(
          note: notes[index],
          onTap: () => _openNote(notes[index]),
        ).animate(delay: (index * 50).ms).fadeIn().slideY(begin: 0.2, end: 0),
      ),
    );
  }

  Widget _buildSliverGrid(List<NoteModel> notes) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, index) => NoteCard(
            note: notes[index],
            onTap: () => _openNote(notes[index]),
          ).animate(delay: (index * 40).ms).fadeIn().slideY(begin: 0.2, end: 0),
          childCount: notes.length,
        ),
      ),
    );
  }

  Widget _buildSliverList(List<NoteModel> notes) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NoteCard(
              note: notes[index],
              onTap: () => _openNote(notes[index]),
              isListMode: true,
            ).animate(delay: (index * 40).ms).fadeIn().slideX(begin: -0.2, end: 0),
          ),
          childCount: notes.length,
        ),
      ),
    );
  }

  void _createNote() {
    final actions = ref.read(notesActionsProvider);
    final note = actions.newNote();
    context.pushNamed('editor', extra: note);
  }

  void _openNote(NoteModel note) {
    context.pushNamed('editor', extra: note);
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _HomeMenuSheet(),
    );
  }
}

class _HomeMenuSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text(AppStrings.archived),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('archived');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text(AppStrings.settings),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed('settings');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
