import 'package:flutter/cupertino.dart';

class HidePasswordProvider with ChangeNotifier{
  bool _isObscurePassword = true;
  bool get  isObscurePassword => _isObscurePassword;

  void setObscure(){
    _isObscurePassword = !_isObscurePassword;
    notifyListeners();
  }
}