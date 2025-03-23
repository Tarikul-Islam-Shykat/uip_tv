import 'package:flutter/material.dart';

class AuthOperationProvider extends ChangeNotifier {
  bool _isUserNameValid = false;
  bool get isUserNameValid => _isUserNameValid;
  void setUserValid({required bool value}) {
    _isUserNameValid = value;
    notifyListeners();
  }

  bool _isEmailValid = false;
  bool get isEmailValid => _isEmailValid;
  void setEmailValid({required bool value}) {
    _isEmailValid = value;
    notifyListeners();
  }

  bool _isPasswordValid = false;
  bool get isPasswordValid => _isPasswordValid;
  void setPasswordValid({required bool value}) {
    _isPasswordValid = value;
    notifyListeners();
  }

  bool _isLoginObscurPassword = false;
  bool get isLoginObscurPassword => _isLoginObscurPassword;
  void setLoginObscurPassword({required bool value}) {
    _isLoginObscurPassword = !value;
    notifyListeners();
  }

  // ! forgetPassword Screen Start
  bool _isSubmitButtonEnable = false;
  bool get isSubmitButtonEnable => _isSubmitButtonEnable;
  void setSubmitButtonEnabled(
      {required String userId, required String mobile}) {
    // Enable button only if exactly one field is filled
    bool isUserIdFilled = userId.isNotEmpty;
    bool isMobileFilled = mobile.isNotEmpty;

    // The button should be enabled when ONLY ONE field is filled
    _isSubmitButtonEnable = (isUserIdFilled && !isMobileFilled) ||
        (!isUserIdFilled && isMobileFilled);

    notifyListeners();
  }

  // ! PIN CONFIRMATION PAGE Start
  bool _isPinCompleted = false;
  bool get isPinCompleted => _isPinCompleted;
  void setIsPinCompleted({required bool value}) {
    _isPinCompleted = value;
    notifyListeners();
  }

  // ! PIN CONFIRMATION PAGE End

  bool _isOTPCompleted = false;
  bool get isOTPCompleted => _isOTPCompleted;
  void setIsOTPCompleted({required bool value}) {
    _isOTPCompleted = value;
    notifyListeners();
  }
}
