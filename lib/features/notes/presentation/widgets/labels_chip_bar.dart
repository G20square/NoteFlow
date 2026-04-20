import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/features/notes/domain/label_model.dart';
import 'package:note_flow/features/notes/presentation/providers/search_provider.dart';

class LabelsChipBar extends ConsumerWidget {
  const LabelsChipBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLabel = ref.watch(selectedLabelIdProvider);
    final labels = LabelModel.defaultLabels;

    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: labels.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedLabel == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: isSelected,
                onSelected: (_) => ref.read(selectedLabelIdProvider.notifier).state = null,
                selectedColor: AppColors.primary.withOpacity(0.15),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }
          final label = labels[index - 1];
          final isSelected = selectedLabel == label.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(label.icon, size: 14, color: isSelected ? label.color : null),
              label: Text(label.name),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedLabelIdProvider.notifier).state =
                    isSelected ? null : label.id;
              },
              selectedColor: label.color.withOpacity(0.15),
              checkmarkColor: label.color,
              labelStyle: TextStyle(
                color: isSelected ? label.color : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
