import 'package:flutter/material.dart';
import 'package:lodgix/screens/login.dart';
import 'package:splash_view/splash_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashView(
        backgroundColor: Colors.white,
        logo: Image.asset(
          "assets/images/otaku.jpg",
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
        done:  Done(
         Login(), 
        ),
        duration: const Duration(milliseconds: 3000),
       
      ),
    );
  }
}