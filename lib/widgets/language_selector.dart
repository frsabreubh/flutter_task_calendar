import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageSelector extends StatefulWidget {
  final VoidCallback onChanged;
  const LanguageSelector({super.key, required this.onChanged});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String _lang;

  @override
  void initState() {
    super.initState();
    final settings = Hive.box('settings');
    _lang = settings.get('lang', defaultValue: 'pt') as String;
  }

  void _changeLang(String code) {
    Hive.box('settings').put('lang', code);
    setState(() => _lang = code);
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('🇧🇷 Português'),
          selected: _lang == 'pt',
          onSelected: (_) => _changeLang('pt'),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('🇺🇸 English'),
          selected: _lang == 'en',
          onSelected: (_) => _changeLang('en'),
        ),
      ],
    );
  }
}
