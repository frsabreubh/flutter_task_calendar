import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lang = Hive.box('settings').get('lang', defaultValue: 'pt');
    String t(String pt, String en) => lang == 'pt' ? pt : en;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(t('Nova Tarefa', 'New Task')),
      content: TextField(
        controller: _ctrl,
        decoration: InputDecoration(hintText: t('Digite o nome da tarefa...', 'Enter task name...')),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('Cancelar', 'Cancel')),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: Text(t('Adicionar', 'Add')),
        ),
      ],
    );
  }
}
