import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:note_flow/core/constants/app_colors.dart';
import 'package:note_flow/core/constants/app_strings.dart';

class LabelModel extends Equatable {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  const LabelModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name];

  static const List<LabelModel> defaultLabels = [
    LabelModel(
      id: 'work',
      name: AppStrings.work,
      color: AppColors.workLabel,
      icon: Icons.work_outline_rounded,
    ),
    LabelModel(
      id: 'personal',
      name: AppStrings.personal,
      color: AppColors.personalLabel,
      icon: Icons.person_outline_rounded,
    ),
    LabelModel(
      id: 'study',
      name: AppStrings.study,
      color: AppColors.studyLabel,
      icon: Icons.school_outlined,
    ),
    LabelModel(
      id: 'ideas',
      name: AppStrings.ideas,
      color: AppColors.ideasLabel,
      icon: Icons.lightbulb_outline_rounded,
    ),
    LabelModel(
      id: 'health',
      name: AppStrings.health,
      color: AppColors.healthLabel,
      icon: Icons.favorite_outline_rounded,
    ),
    LabelModel(
      id: 'finance',
      name: AppStrings.finance,
      color: AppColors.financeLabel,
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  static LabelModel? findById(String id) {
    try {
      return defaultLabels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
