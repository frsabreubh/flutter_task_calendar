import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/task.dart';
import 'screens/auth_screen.dart';
import 'screens/calendar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox('users');
  await Hive.openBox('session');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('settings');

  // Inicializa formatação de datas (necessário para o TableCalendar)
  await initializeDateFormatting('pt_BR', null);
  await initializeDateFormatting('en_US', null);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final lang = Hive.box('settings').get('lang', defaultValue: 'pt');
    final session = Hive.box('session');
    final loggedUser = session.get('user');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task Calendar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      locale: Locale(lang == 'pt' ? 'pt' : 'en'),
      home: loggedUser == null
          ? const AuthScreen()
          : const CalendarScreen(),
    );
  }
}
