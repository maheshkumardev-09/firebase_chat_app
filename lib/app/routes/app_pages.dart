import 'package:firebase_chat_app/app/view/forgot_screen.dart';
import 'package:firebase_chat_app/app/view/home_screen.dart';
import 'package:firebase_chat_app/app/view/sign_up_screen.dart';
import 'package:firebase_chat_app/app/view/splash_screen.dart';
import 'package:firebase_chat_app/app/view/login_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/signup', page: () => SignUpScreen()),
    GetPage(name: '/forgot', page: () => ForgotScreen()),
  ];
}
