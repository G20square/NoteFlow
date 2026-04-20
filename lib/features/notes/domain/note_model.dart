import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class NoteModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> imageUrls;
  final List<String> labelIds;
  final bool isPinned;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int colorIndex; // 0-9 from AppColors.noteColors*

  const NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    this.labelIds = const [],
    this.isPinned = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.colorIndex = 0,
  });

  factory NoteModel.create({required String userId}) {
    final now = DateTime.now();
    return NoteModel(
      id: const Uuid().v4(),
      userId: userId,
      title: '',
      content: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? imageUrls,
    List<String>? labelIds,
    bool? isPinned,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? colorIndex,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      labelIds: labelIds ?? this.labelIds,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'labelIds': labelIds,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'colorIndex': colorIndex,
    };
  }

  factory NoteModel.fromFirestore(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
      labelIds: List<String>.from(map['labelIds'] as List? ?? []),
      isPinned: map['isPinned'] as bool? ?? false,
      isArchived: map['isArchived'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      colorIndex: map['colorIndex'] as int? ?? 0,
    );
  }

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        content,
        imageUrls,
        labelIds,
        isPinned,
        isArchived,
        createdAt,
        updatedAt,
        colorIndex,
      ];
}
