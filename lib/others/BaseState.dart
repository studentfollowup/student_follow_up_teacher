import 'package:flutter/material.dart';
import 'BaseView.dart';
import 'LoadingDialog.dart';
import 'Utils.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    implements BaseView {
  LoadingDialog loadingDialog = new LoadingDialog();
  @override
  void showLoginDialog() {
//    if user authenticated
//      LoginDialog.show(context);
  }

  @override
  void hideProgress() {
    loadingDialog.hide();
  }

  @override
  void showProgress() {
    loadingDialog.show();
  }

  @override
  void showSuccessMsg(String msg) {
    Utils.showSuccessSnackbar(msg);
  }

  @override
  void showErrorMsg(String msg) {
    Utils.showErrorSnackbar(msg);
  }
}
