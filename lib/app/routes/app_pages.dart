import 'package:firebase_chat_app/app/view/auth_screens/forgot_screen.dart';
import 'package:firebase_chat_app/app/view/home_bottum_bar.dart';
import 'package:firebase_chat_app/app/view/auth_screens/sign_up_screen.dart';
import 'package:firebase_chat_app/app/view/auth_screens/splash_screen.dart';
import 'package:firebase_chat_app/app/view/auth_screens/login_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginView()),
    GetPage(name: '/home', page: () => HomeBottomBar()),
    GetPage(name: '/signup', page: () => SignUpScreen()),
    GetPage(name: '/forgot', page: () => ForgotScreen()),
  ];
}
