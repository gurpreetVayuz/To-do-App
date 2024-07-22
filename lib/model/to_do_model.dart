import 'package:hive_flutter/hive_flutter.dart';

part 'to_do_model.g.dart';

@HiveType(typeId: 0)
class ToDoModel {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime? datecreated;

  @HiveField(3)
  late bool completed;

  ToDoModel(
      {required this.title,
      required this.description,
      required this.datecreated,
      required this.completed});
}
