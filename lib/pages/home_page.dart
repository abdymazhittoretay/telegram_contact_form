import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final String? _botToken = dotenv.env["BOT_TOKEN"];
  final String? _chatID = dotenv.env["CHAT_ID"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Your name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? "Enter your name"
                                : null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Your email",
                      border: OutlineInputBorder(),
                    ),
                    validator: validateEmail,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Your message",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? "Enter your message"
                                : null,
                    maxLines: 4,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: LinearBorder(),
                      minimumSize: Size(double.maxFinite, 75),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await sendMessage();
                        confirmationDialog();
                        _nameController.clear();
                        _emailController.clear();
                        _messageController.clear();
                      }
                    },
                    child: Text("Send", style: TextStyle(fontSize: 22.0)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    final String message = '''
New contact request:
Name: ${_nameController.text}
Email: ${_emailController.text}
Message: ${_messageController.text}
''';
    final url = Uri.parse('https://api.telegram.org/bot$_botToken/sendMessage');

    await http.post(url, body: {"chat_id": _chatID, "text": message});
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your email";
    }
    const pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return regex.hasMatch(value) ? null : "Enter a valid email address";
  }

  void confirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: LinearBorder(),
            content: Text(
              "Your message was sent!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(100, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK", style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
    );
  }
}
