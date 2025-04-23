import 'package:flutter/material.dart';

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
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? "Enter your email"
                                : null,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Your message",
                      border: OutlineInputBorder(),
                    ),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
