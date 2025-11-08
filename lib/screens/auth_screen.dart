import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import '../widgets/language_selector.dart';
import 'calendar_screen.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;

  String get lang => Hive.box('settings').get('lang', defaultValue: 'pt');
  String t(String pt, String en) => lang == 'pt' ? pt : en;
  String _hash(String s) => sha256.convert(utf8.encode(s)).toString();

  void _submit() {
    final usersBox = Hive.box('users');
    final session = Hive.box('session');
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text;

    if (username.isEmpty || password.isEmpty) return;

    if (_isLogin) {
      final stored = usersBox.get(username);
      if (stored == null) {
        _showSnack(t('Usuário não encontrado', 'User not found'));
        _userCtrl.clear();
        _passCtrl.clear();
        return;
      }
      if (stored != _hash(password)) {
        _showSnack(t('Senha incorreta', 'Incorrect password'));
        _passCtrl.clear();
        return;
      }
      session.put('user', username);
    } else {
      if (usersBox.containsKey(username)) {
        _showSnack(t('Usuário já existe', 'User already exists'));
        return;
      }
      usersBox.put(username, _hash(password));
      session.put('user', username);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  void _showSnack(String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  void _exitApp() async {
    final session = Hive.box('session');
    await session.clear();
    exit(0); // encerra o app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.pink.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _exitApp,
                      ),
                    ),
                    LanguageSelector(onChanged: () => setState(() {})),
                    const SizedBox(height: 16),
                    Text(
                      'Task Calendar',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? t('Faça login', 'Login')
                          : t('Crie uma conta', 'Sign up'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _userCtrl,
                      decoration: InputDecoration(
                        labelText: t('Usuário', 'Username'),
                        border: const UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passCtrl,
                      decoration: InputDecoration(
                        labelText: t('Senha', 'Password'),
                        border: const UnderlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin
                          ? t('Entrar', 'Login')
                          : t('Cadastrar', 'Sign up')),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin
                          ? t('Criar conta', 'Create account')
                          : t('Já tenho conta', 'Already have account')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
