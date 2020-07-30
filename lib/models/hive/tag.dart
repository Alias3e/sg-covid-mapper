import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 1)
class Tag extends HiveObject {
  @HiveField(0)
  final String label;
  @HiveField(1)
  bool isVisitedByInfected = false;

  Tag(this.label);
}
