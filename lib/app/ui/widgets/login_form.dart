import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_settings.dart';
import 'package:peopler/app/ui/viewmodels/login_page_vm.dart';

// 1. Change to ConsumerStatefulWidget
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

// 2. Create the State class
class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  // 3. Declare controllers here
  late final TextEditingController _userController;
  late final TextEditingController _passwordController;

  // 4. Initialize in initState
  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _passwordController = TextEditingController();
  }

  // 5. Dispose in dispose
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: No WidgetRef here
    // Access ref via the 'ref' property inherited from ConsumerState
    final state = ref.watch(loginPageVMProvider);
    final viewModel = ref.read(loginPageVMProvider.notifier);

    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userController, // Use initialized controller
                decoration: const InputDecoration(
                  hintText: 'User id',
                ),
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Please enter user id';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController, // Use initialized controller
                obscureText: state.hidePassword,
                decoration: const InputDecoration(
                  hintText: 'User password',
                ),
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Please enter user password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: state.isProcessing
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.login(
                                username: _userController.text,
                                password: _passwordController.text,
                                context: context,
                              );
                            }
                          },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 90),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.togglePasswordVisibility();
                    },
                    child: state.hidePassword
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
