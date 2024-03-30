import 'package:flutter/material.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/pages/person_list_page.dart';
import 'package:peopler/widgets/snack_message.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userCtl = TextEditingController();
  final pwdCtl = TextEditingController();
  bool isProcessing = false;

  VoidCallback? submitAction() {
    if (isProcessing) {
      return null;
    } else {
      return () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isProcessing = true;
          });
          SnackMessage.showMessage(
              context: context, message: 'Processing', messageType: MessageType.info);
          Credentials.login(userName: userCtl.text, password: pwdCtl.text, context: context)
              .then((loggedIn) {
            setState(() {
              isProcessing = false;
            });
            if (loggedIn) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const PersonListPage()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login failed'),
                duration: Duration(seconds: 0, milliseconds: 500),
                backgroundColor: Colors.red,
              ));
            }
          });
        }
      };
    }
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
                  controller: userCtl,
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
                  controller: pwdCtl,
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
                ElevatedButton(
                  onPressed: submitAction(),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}
