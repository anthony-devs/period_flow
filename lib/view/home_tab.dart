import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/cycle.dart';
import './signup.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> logout(BuildContext context) async {
    final userBox = Hive.box<User>('users');
    await userBox.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignupPage()),
      (route) => false,
    );
  }

  void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Log out?"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await logout(context);
            },
            child: const Text("Log out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('users');
    final user = userBox.get(1);

    if (user == null || user.cycles == null || user.cycles!.isEmpty) {
      return Center(child: Text('No period data yet.'));
    }

    final latestCycle = user.cycles!.last;
    final lastStartDate = DateTime(
      latestCycle.year,
      latestCycle.month,
      latestCycle.periodStartDay,
    );
    final nextPeriodDate = lastStartDate.add(Duration(days: user.cycleLength));
    final ovulationDate = lastStartDate.add(
      Duration(days: (user.cycleLength / 2).floor()),
    );
    final currentCycleDay = DateTime.now().difference(lastStartDate).inDays + 1;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome,"),
            Row(
              children: [
                Text(
                  "${user.name}",
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => confirmLogout(context),
                ),
              ],
            ),
            Text(
              "Your Cycle",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              child: ListTile(
                title: Text("Days till next period"),
                subtitle: Text(
                  "${nextPeriodDate.difference(DateTime.now()).inDays} days",
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: ListTile(
                title: Text("Next Period"),
                subtitle: Text(DateFormat.yMMMMd().format(nextPeriodDate)),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Next Ovulation"),
                subtitle: Text(DateFormat.yMMMMd().format(ovulationDate)),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Current Cycle Day"),
                subtitle: Text("Day $currentCycleDay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
