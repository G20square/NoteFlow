import 'package:hive/hive.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';

part 'note_hive_model.g.dart';

@HiveType(typeId: 0)
class NoteHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String content;

  @HiveField(4)
  late List<String> imageUrls;

  @HiveField(5)
  late List<String> labelIds;

  @HiveField(6)
  late bool isPinned;

  @HiveField(7)
  late bool isArchived;

  @HiveField(8)
  late String createdAt;

  @HiveField(9)
  late String updatedAt;

  @HiveField(10)
  late int colorIndex;

  NoteHiveModel();

  factory NoteHiveModel.fromDomain(NoteModel note) {
    return NoteHiveModel()
      ..id = note.id
      ..userId = note.userId
      ..title = note.title
      ..content = note.content
      ..imageUrls = List<String>.from(note.imageUrls)
      ..labelIds = List<String>.from(note.labelIds)
      ..isPinned = note.isPinned
      ..isArchived = note.isArchived
      ..createdAt = note.createdAt.toIso8601String()
      ..updatedAt = note.updatedAt.toIso8601String()
      ..colorIndex = note.colorIndex;
  }

  NoteModel toDomain() {
    return NoteModel(
      id: id,
      userId: userId,
      title: title,
      content: content,
      imageUrls: List<String>.from(imageUrls),
      labelIds: List<String>.from(labelIds),
      isPinned: isPinned,
      isArchived: isArchived,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      colorIndex: colorIndex,
    );
  }
}
