import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:period_flow/view/home.dart';
import 'package:period_flow/view/signup.dart';
import 'models/user.dart';
import 'models/cycle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CycleAdapter());

  await Hive.openBox<User>('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('users');
    final hasUser = userBox.isNotEmpty;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: hasUser ? const HomePage() : const SignupPage(),
    );
  }
}
