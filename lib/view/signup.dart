import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/cycle.dart';
import 'home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _periodLength = 5;
  int _cycleLength = 28;
  bool _isRegular = true;
  DateTime? _lastPeriodStart;

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _createUser() async {
    if (_lastPeriodStart == null) return;

    final box = Hive.box<User>('users');
    final today = DateTime.now();

    final cycle = Cycle(
      year: _lastPeriodStart!.year,
      month: _lastPeriodStart!.month,
      periodStartDay: _lastPeriodStart!.day,
      periodLength: _periodLength,
      cycleLength: _cycleLength,
    );

    final user = User(
      id: 1,
      name: _nameController.text.trim(),
      periodLength: _periodLength,
      cycleLength: _cycleLength,
      regularCycle: _isRegular,
      cycles: [cycle],
    );

    await box.put(user.id, user);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildNamePage(),
          _buildPeriodLengthPage(),
          _buildCycleLengthPage(),
          _buildRegularityPage(),
          _buildLastPeriodPage(),
        ],
      ),
    );
  }

  Widget _buildNamePage() {
    return _SignupStep(
      title: "What Shall We Call You?",
      subtitle: "Write a name you love us to call you",
      child: TextField(
        controller: _nameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Joanna Doe?",
          hintStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFBCBCBC),
          ),
        ),
      ),
      onNext: () {
        if (_nameController.text.trim().isNotEmpty) {
          _nextPage();
        }
      },
    );
  }

  Widget _buildPeriodLengthPage() {
    return _SignupStep(
      title: "Average Period Length?",
      subtitle: "How long does your period usually last (in days)?",
      child: DropdownButton<int>(
        value: _periodLength,
        items: List.generate(10, (i) => i + 1)
            .map(
              (day) => DropdownMenuItem(value: day, child: Text("$day days")),
            )
            .toList(),
        onChanged: (val) => setState(() => _periodLength = val!),
      ),
      onNext: _nextPage,
    );
  }

  Widget _buildCycleLengthPage() {
    return _SignupStep(
      title: "Average Cycle Length?",
      subtitle: "How long is your full cycle (period to period)?",
      child: DropdownButton<int>(
        value: _cycleLength,
        items: List.generate(20, (i) => i + 21)
            .map(
              (day) => DropdownMenuItem(value: day, child: Text("$day days")),
            )
            .toList(),
        onChanged: (val) => setState(() => _cycleLength = val!),
      ),
      onNext: _nextPage,
    );
  }

  Widget _buildRegularityPage() {
    return _SignupStep(
      title: "Is Your Cycle Regular?",
      subtitle: "Do your periods come around the same time every month?",
      child: ToggleButtons(
        isSelected: [_isRegular, !_isRegular],
        children: [Text("Yes"), Text("No")],
        onPressed: (index) {
          setState(() => _isRegular = index == 0);
        },
      ),
      onNext: _nextPage,
    );
  }

  Widget _buildLastPeriodPage() {
    return _SignupStep(
      title: "When Did Your Last Period Start?",
      subtitle: "Pick the first day of your most recent period",
      child: ElevatedButton(
        onPressed: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year - 2),
            lastDate: now,
          );
          if (picked != null) {
            setState(() => _lastPeriodStart = picked);
          }
        },
        child: Text(
          _lastPeriodStart == null
              ? "Select Date"
              : "${_lastPeriodStart!.day}/${_lastPeriodStart!.month}/${_lastPeriodStart!.year}",
        ),
      ),
      onNext: _createUser,
    );
  }
}

class _SignupStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onNext;

  const _SignupStep({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.normal,
            ),
          ),
          Spacer(),
          Center(child: child),
          Spacer(),
          Center(
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                height: 50,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFCD4FFF),
                ),
                child: Center(
                  child: Text(
                    "That's Me",
                    style: GoogleFonts.spaceGrotesk(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
