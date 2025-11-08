# 🗓️ Flutter Task Calendar

Um aplicativo desenvolvido em **Flutter** para gerenciamento de tarefas diárias com autenticação local, armazenamento persistente com **Hive** e visualização interativa por meio de um **calendário inteligente**.

---

## 🚀 Funcionalidades

- **Autenticação de Usuário Local**
  - Registro e login de usuários com criptografia **SHA-256**.
  - Armazenamento local seguro utilizando **Hive**.
  - Controle de sessão e logout automático.

- **Gerenciamento de Tarefas**
  - Adição, edição e exclusão de tarefas.
  - Marcação de tarefas como concluídas.
  - Exibição das tarefas associadas à data selecionada.

- **Calendário Interativo**
  - Destaque visual dos dias com tarefas:
    - **Borda vermelha** → Tarefas pendentes.
    - **Borda verde** → Todas as tarefas concluídas.
  - Atualização dinâmica ao modificar tarefas.

- **Interface Bilíngue**
  - Suporte para **português e inglês**.
  - Alternância de idioma diretamente na tela de autenticação.

- **Interface Moderna**
  - Design baseado no **Material Design 3**.
  - Cores vibrantes e animações suaves.
  - Mensagens informativas guiando a interação do usuário.

---

## 🧱 Estrutura do Projeto

lib/
├── main.dart
├── models/
│ └── task.dart
├── screens/
│ ├── auth_screen.dart
│ ├── calendar_screen.dart
│ └── tasks_screen.dart
└── widgets/
├── add_task_dialog.dart
├── edit_task_dialog.dart
└── language_selector.dart


---

## ⚙️ Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Hive](https://pub.dev/packages/hive)
- [Hive Flutter](https://pub.dev/packages/hive_flutter)
- [Table Calendar](https://pub.dev/packages/table_calendar)
- [Crypto](https://pub.dev/packages/crypto)

---

## 🧩 Instalação e Execução

### 1️⃣ Pré-requisitos
- Flutter SDK instalado ([instruções oficiais](https://flutter.dev/docs/get-started/install))
- Android Studio ou VS Code configurado
- Emulador Android ou dispositivo físico conectado

### 2️⃣ Clonar o repositório
```bash
git clone https://github.com/frsabreubh/flutter_task_calendar.git
cd flutter_task_calendar

flutter pub get
flutter run

dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  table_calendar: ^3.1.1
  crypto: ^3.0.3
  intl: ^0.20.2

👨‍💻 Autor

Desenvolvido por: Franklin Abreu
📧 Contato: franklin.abreu@hotmail.com

🪪 Licença

Este projeto é distribuído sob a licença MIT.
Sinta-se livre para usar, modificar e compartilhar.
