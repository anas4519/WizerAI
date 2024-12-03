import 'package:career_counsellor/auth/auth_service.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiGuidance extends StatefulWidget {
  const AiGuidance({super.key});

  @override
  State<AiGuidance> createState() => _AiGuidanceState();
}

class _AiGuidanceState extends State<AiGuidance> {
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello ${currEmail.toString()}!',
              style: const TextStyle(fontSize: 20),
            ),
            const Text('Ready to take the survey?'),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const SelectEducation()));
                },
                icon: const Icon(CupertinoIcons.arrow_right))
          ],
        ),
      ),
    );
  }
}
