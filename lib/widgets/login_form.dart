import 'package:flutter/material.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/pages/index_page.dart';
import 'dart:developer';

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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Processing'),
            duration: Duration(seconds: 0, microseconds: 500),
          ));
          Credentials.login(userName: userCtl.text, password: pwdCtl.text).then((result) {
            setState(() {
              isProcessing = false;
            });
            if (result) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const IndexPage()));
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //   content: Text('Login success'),
              //   duration: Duration(seconds: 0, microseconds: 500),
              // ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login failed'),
                duration: Duration(seconds: 0, microseconds: 500),
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
            ElevatedButton(
              onPressed: () async {
                final token = await Credentials.getToken();
                log('Stored token: $token');
              },
              child: const Text('Check persistence data'),
            )
          ],
        ));
  }
}
