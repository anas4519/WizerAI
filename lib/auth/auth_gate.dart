/*
listens for auth state changes

unauthenticated = login page
authenticated = main page
*/

import 'package:career_counsellor/pages/auth/login_page.dart';
import 'package:career_counsellor/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;
          if (session != null) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        });
  }
}
