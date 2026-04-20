import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/core/constants/app_strings.dart';
import 'package:note_flow/features/notes/presentation/providers/search_provider.dart';
import 'package:note_flow/features/notes/presentation/widgets/empty_state.dart';
import 'package:note_flow/features/notes/presentation/widgets/note_card.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _controller.text;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    ref.read(searchQueryProvider.notifier).state = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: AppStrings.search,
            border: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: query.isEmpty
          ? const EmptyState(
              icon: Icons.search_rounded,
              title: 'Search your notes',
              subtitle: 'Type to search by title or content',
            )
          : results.isEmpty
              ? const EmptyState(
                  icon: Icons.sentiment_dissatisfied_outlined,
                  title: AppStrings.noResults,
                  subtitle: AppStrings.noResultsSubtitle,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: results.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NoteCard(
                      note: results[index],
                      isListMode: true,
                      onTap: () => context.pushNamed('editor', extra: results[index]),
                    ).animate(delay: (index * 40).ms).fadeIn().slideY(begin: 0.2, end: 0),
                  ),
                ),
    );
  }
}
