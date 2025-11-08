import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';

class TasksScreen extends StatefulWidget {
  final DateTime date;
  final VoidCallback onUpdateTasks;

  const TasksScreen({
    super.key,
    required this.date,
    required this.onUpdateTasks,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Box<Task> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
  }

  List<Task> get _tasks {
    final all = _taskBox.values.where((t) =>
    t.date.year == widget.date.year &&
        t.date.month == widget.date.month &&
        t.date.day == widget.date.day);
    final pending = all.where((t) => !t.completed).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final done = all.where((t) => t.completed).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return [...pending, ...done];
  }

  void _addTask(String name) {
    _taskBox.add(Task(name: name, date: widget.date));
    widget.onUpdateTasks();
    setState(() {});
  }

  void _editTask(Task task) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => EditTaskDialog(initialName: task.name),
    );
    if (newName != null && newName.trim().isNotEmpty) {
      task.name = newName.trim();
      task.save();
      widget.onUpdateTasks();
      setState(() {});
    }
  }

  Future<void> _deleteTask(Task task) async {
    final lang = Hive.box('settings').get('lang', defaultValue: 'pt');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'pt' ? 'Confirmar exclusão' : 'Confirm delete'),
        content: Text(lang == 'pt'
            ? 'Tem certeza que deseja excluir esta tarefa?'
            : 'Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang == 'pt' ? 'Cancelar' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(lang == 'pt' ? 'Excluir' : 'Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await task.delete();
      widget.onUpdateTasks();
      setState(() {});
    }
  }

  void _toggle(Task task) {
    task.completed = !task.completed;
    task.save();
    widget.onUpdateTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = Hive.box('settings').get('lang', defaultValue: 'pt');
    String t(String pt, String en) => lang == 'pt' ? pt : en;

    return Scaffold(
      appBar: AppBar(title: Text(t('Tarefas do Dia', 'Day Tasks'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (ctx) => AddTaskDialog(),
          );
          if (name != null && name.trim().isNotEmpty) {
            _addTask(name.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _tasks.isEmpty
          ? Center(
        child: Text(
          t('Nenhuma tarefa para este dia.', 'No tasks for this day.'),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (ctx, i) {
          final task = _tasks[i];
          return Card(
            color: task.completed
                ? Colors.greenAccent.withOpacity(0.3)
                : Colors.pinkAccent.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                task.name,
                style: TextStyle(
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Checkbox(
                value: task.completed,
                onChanged: (_) => _toggle(task),
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    tooltip: t('Editar tarefa', 'Edit task'),
                    onPressed: () => _editTask(task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    tooltip: t('Excluir tarefa', 'Delete task'),
                    onPressed: () => _deleteTask(task),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
