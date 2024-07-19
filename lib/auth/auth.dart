import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:where_wear/auth/login_or_register.dart';
import 'package:where_wear/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if 登入
          if (snapshot.hasData) {
            return HomePage();
          }

          // if 沒有都入
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
