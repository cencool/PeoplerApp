import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  late final messengerKey = context.read<AppState>().messengerKey;
  bool isProcessing = false;
  bool hidePassword = true;

  VoidCallback submitAction() {
    return () {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isProcessing = true;
        });
        SnackMessage.showMessage(
            messengerKey: messengerKey, message: 'Processing', messageType: MessageType.info);
        Credentials.login(
                userName: userController.text, password: passwordController.text, context: context)
            .then((loggedIn) {
          setState(() {
            isProcessing = false;
          });
          if (loggedIn) {
            context.read<AppState>().login();
          } else {
            SnackMessage.showMessage(
                messengerKey: messengerKey,
                message: 'Login Failed',
                messageType: MessageType.error);
          }
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  hintText: 'User id',
                ),
                validator: (String? value) {
                  if (value != null) {
                    value = value.trim();
                  }
                  if (value == null || value.isEmpty) {
                    return "Please enter user id";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: const InputDecoration(
                  hintText: 'User password',
                ),
                validator: (String? value) {
                  if (value != null) {
                    value = value.trim();
                  }
                  if (value == null || value.isEmpty) {
                    return "Please enter user password";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: isProcessing ? null : submitAction(),
                    child: const Text('Submit'),
                  ),
                  SizedBox(
                    width: 90,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      child: (hidePassword)
                          ? Icon(Icons.visibility_outlined)
                          : Icon(Icons.visibility_off_outlined)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
