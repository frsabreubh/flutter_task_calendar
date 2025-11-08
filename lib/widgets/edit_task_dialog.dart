import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditTaskDialog extends StatefulWidget {
  final String initialName;
  const EditTaskDialog({super.key, required this.initialName});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Hive.box('settings').get('lang', defaultValue: 'pt');
    String t(String pt, String en) => lang == 'pt' ? pt : en;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(t('Editar Tarefa', 'Edit Task')),
      content: TextField(
        controller: _ctrl,
        decoration: InputDecoration(hintText: t('Novo nome...', 'New name...')),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t('Cancelar', 'Cancel')),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _ctrl.text),
          child: Text(t('Salvar', 'Save')),
        ),
      ],
    );
  }
}
