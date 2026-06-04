import 'package:firebase_chat_app/features/auth/views/forgot_screen.dart';
import 'package:firebase_chat_app/features/people/views/people_main_screen.dart';
import 'package:firebase_chat_app/features/profile/views/change_password_screen.dart';
import 'package:firebase_chat_app/features/profile/views/edit_profile_screen.dart';
import 'package:firebase_chat_app/widgets/bottom_navigation.dart';
import 'package:firebase_chat_app/features/auth/views/sign_up_screen.dart';
import 'package:firebase_chat_app/widgets/splash_screen.dart';
import 'package:firebase_chat_app/features/auth/views/login_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/home', page: () => BottomNavigation()),
    GetPage(name: '/signup', page: () => SignUpScreen()),
    GetPage(name: '/forgot', page: () => ForgotScreen()),
    GetPage(name: '/editprofile', page: () => EditProfileScreen()),
    GetPage(name: '/change-password', page: () => ChangePasswordScreen()),
    GetPage(name: '/people', page: () => PeopleMainScreen()),
  ];
}
