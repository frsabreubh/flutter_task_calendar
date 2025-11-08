import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import 'tasks_screen.dart';
import 'auth_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Box<Task> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  String get lang => Hive.box('settings').get('lang', defaultValue: 'pt');
  String t(String pt, String en) => lang == 'pt' ? pt : en;

  List<Task> _tasksForDay(DateTime day) {
    return _taskBox.values.where((task) {
      return task.date.year == day.year &&
          task.date.month == day.month &&
          task.date.day == day.day;
    }).toList();
  }

  bool _hasPendingTasks(DateTime day) {
    return _tasksForDay(day).any((t) => !t.completed);
  }

  bool _hasCompletedTasks(DateTime day) {
    return _tasksForDay(day).isNotEmpty &&
        _tasksForDay(day).every((t) => t.completed);
  }

  void _logout() async {
    final session = Hive.box('session');
    await session.clear();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  void _openTasksScreen(DateTime day) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TasksScreen(
          date: day,
          onUpdateTasks: () => setState(() {}), // 🔹 atualiza o calendário dinamicamente
        ),
      ),
    );
    setState(() {}); // Atualiza ao retornar
  }

  @override
  Widget build(BuildContext context) {
    final selectedTasks =
    _selectedDay != null ? _tasksForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'pt' ? 'Calendário de Tarefas' : 'Task Calendar',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: t('Sair', 'Logout'),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Task>(
            locale: lang == 'pt' ? 'pt_BR' : 'en_US',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay ?? DateTime.now(), day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _openTasksScreen(selectedDay);
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                bool hasPending = _hasPendingTasks(day);
                bool allCompleted = _hasCompletedTasks(day);

                Color? borderColor;
                if (hasPending) {
                  borderColor = Colors.redAccent;
                } else if (allCompleted) {
                  borderColor = Colors.green;
                }

                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: borderColor != null
                        ? Border.all(color: borderColor, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                t('Selecione uma data para ver as tarefas.',
                    'Select a date to view tasks.'),
                textAlign: TextAlign.center,
              ),
            )
          else if (selectedTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                t('Nenhuma tarefa para esta data.', 'No tasks for this date.'),
                textAlign: TextAlign.center,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                t('Toque na data para gerenciar as tarefas.',
                    'Tap the date to manage tasks.'),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
