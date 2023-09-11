import 'package:flutter/cupertino.dart';
import 'package:store/FireBase/Models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? _) => [_user = _, notifyListeners()];
}
