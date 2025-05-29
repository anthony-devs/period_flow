import 'package:hive/hive.dart';

part 'cycle.g.dart';

@HiveType(typeId: 1)
class Cycle {
  @HiveField(0)
  int year;

  @HiveField(1)
  int month;

  @HiveField(2)
  int periodStartDay;

  @HiveField(3)
  int periodLength;

  @HiveField(4)
  int cycleLength;

  Cycle({
    required this.year,
    required this.month,
    required this.periodStartDay,
    required this.periodLength,
    required this.cycleLength,
  });
}
