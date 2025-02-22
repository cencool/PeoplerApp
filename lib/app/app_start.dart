import 'package:flutter/foundation.dart';
import 'package:peopler/app/domain/models/user.dart';

void initApp() async {
  debugPrint("App Starting...");
  if (await User.autoLogin() != null) return;
  User user = User(id: 'admin');
  user.password = 'lolo';
  await user.login();
}
