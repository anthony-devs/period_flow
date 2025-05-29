import 'package:hive/hive.dart';
import 'package:period_flow/models/cycle.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int periodLength;

  @HiveField(3)
  int cycleLength;

  @HiveField(4)
  bool? regularCycle;

  @HiveField(5)
  List<Cycle>? cycles;

  User({
    required this.id,
    required this.name,
    this.periodLength = 5,
    this.cycleLength = 21,
    this.regularCycle = true,
    this.cycles,
  });
}
