import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/splash/splash.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(title: Text('4Dev')),
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.offAllNamed(page);
            }
          });

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
