import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Hive.box<User>('users').get(1);
    if (user == null || user.cycles == null)
      return Center(child: Text("No data"));

    final Map<DateTime, String> markers = {};

    for (var cycle in user.cycles!) {
      final start = DateTime(cycle.year, cycle.month, cycle.periodStartDay);
      for (int i = 0; i < cycle.periodLength; i++) {
        markers[start.add(Duration(days: i))] = 'period';
      }
      final ovulation = start.add(
        Duration(days: (cycle.cycleLength / 2).floor()),
      );
      markers[ovulation] = 'ovulation';
      for (int i = 9; i <= 19; i++) {
        markers[start.add(Duration(days: i))] ??= 'fertility';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        firstDay: DateTime.utc(2023),
        lastDay: DateTime.utc(2030),
        focusedDay: DateTime.now(),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final mark = markers[DateTime(day.year, day.month, day.day)];
            Color? color;
            if (mark == 'period')
              color = Colors.pink[200];
            else if (mark == 'ovulation')
              color = Colors.green;
            else if (mark == 'fertility')
              color = Colors.yellow[600];
            return Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              alignment: Alignment.center,
              child: Text('${day.day}'),
            );
          },
        ),
      ),
    );
  }
}
