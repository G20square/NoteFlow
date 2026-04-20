import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/theme/theme_provider.dart';
import 'package:note_flow/core/utils/date_utils.dart';
import 'package:note_flow/features/notes/domain/label_model.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';
import 'package:note_flow/features/notes/presentation/providers/notes_provider.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteModel _note;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? ref.read(notesActionsProvider).newNote();
    _titleController = TextEditingController(text: _note.title);
    _contentController = TextEditingController(text: _note.content);
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
    _note = _note.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save({bool silent = false}) async {
    if (_note.isEmpty) return;
    _note = _note.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      updatedAt: DateTime.now(),
    );
    await ref.read(notesActionsProvider).saveNote(_note);
    if (!silent && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved ✓')),
      );
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 85);
    if (image == null) return;
    // TODO: Upload to Firebase Storage and get URL
    // For now, store local path as placeholder
    setState(() {
      _note = _note.copyWith(imageUrls: [..._note.imageUrls, image.path]);
      _hasChanges = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image added (sync on Firebase setup)')),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;
    final colors = isDark ? AppColors.noteColorsDark : AppColors.noteColorsLight;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Note color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(colors.length, (i) => GestureDetector(
                onTap: () {
                  setState(() => _note = _note.copyWith(colorIndex: i, updatedAt: DateTime.now()));
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _note.colorIndex == i ? AppColors.primary : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: _note.colorIndex == i
                      ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 18)
                      : null,
                ),
              )),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLabelPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add label', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: LabelModel.defaultLabels.map((label) {
                  final isSelected = _note.labelIds.contains(label.id);
                  return FilterChip(
                    avatar: Icon(label.icon, size: 14, color: isSelected ? label.color : null),
                    label: Text(label.name),
                    selected: isSelected,
                    onSelected: (_) {
                      setModalState(() {
                        final ids = List<String>.from(_note.labelIds);
                        isSelected ? ids.remove(label.id) : ids.add(label.id);
                        _note = _note.copyWith(labelIds: ids, updatedAt: DateTime.now());
                        _hasChanges = true;
                      });
                      setState(() {});
                    },
                    selectedColor: label.color.withOpacity(0.15),
                    checkmarkColor: label.color,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final noteColors = isDark ? AppColors.noteColorsDark : AppColors.noteColorsLight;
    final bgColor = noteColors[_note.colorIndex.clamp(0, noteColors.length - 1)];
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          await _save(silent: true);
          if (mounted) context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () async {
              await _save(silent: true);
              if (mounted) context.pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                color: _note.isPinned ? AppColors.primary : null,
              ),
              tooltip: _note.isPinned ? 'Unpin' : 'Pin',
              onPressed: () => setState(() {
                _note = _note.copyWith(isPinned: !_note.isPinned);
                _hasChanges = true;
              }),
            ),
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              tooltip: 'Note color',
              onPressed: _showColorPicker,
            ),
            IconButton(
              icon: const Icon(Icons.image_outlined),
              tooltip: 'Add image',
              onPressed: _showImagePicker,
            ),
            IconButton(
              icon: const Icon(Icons.label_outline_rounded),
              tooltip: 'Labels',
              onPressed: _showLabelPicker,
            ),
            if (_hasChanges)
              IconButton(
                icon: const Icon(Icons.check_rounded, color: AppColors.primary),
                tooltip: 'Save',
                onPressed: _save,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images
              if (_note.imageUrls.isNotEmpty) ...[
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _note.imageUrls.length,
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          _note.imageUrls[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image_outlined, size: 32, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: -0.1),
                const SizedBox(height: 16),
              ],
              // Title
              TextField(
                controller: _titleController,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              // Date
              Text(
                NoteDate.fullFormat(_note.updatedAt),
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 16),
              // Content
              TextField(
                controller: _contentController,
                style: theme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'Write a note...',
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              // Labels display
              if (_note.labelIds.isNotEmpty) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  children: _note.labelIds.map((id) {
                    final label = LabelModel.findById(id);
                    if (label == null) return const SizedBox.shrink();
                    return Chip(
                      avatar: Icon(label.icon, size: 14, color: label.color),
                      label: Text(label.name, style: TextStyle(color: label.color, fontWeight: FontWeight.w600)),
                      backgroundColor: label.color.withOpacity(0.12),
                      side: BorderSide(color: label.color.withOpacity(0.3)),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
