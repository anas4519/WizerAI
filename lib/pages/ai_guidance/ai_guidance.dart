import 'package:career_counsellor/auth/auth_service.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiGuidance extends StatefulWidget {
  const AiGuidance({super.key});

  @override
  State<AiGuidance> createState() => _AiGuidanceState();
}

class _AiGuidanceState extends State<AiGuidance> {
  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;
  final _genderController = TextEditingController();
  final _nameController = TextEditingController();
  void logout() async {
    await authService.signOut();
  }

  String name = 'User';

  Future<void> getName() async {
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase.from('profiles').select().eq('id', userId).single();
    name = data['full_name'];
    print(data);
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              'Hello ${name}!',
              style: const TextStyle(fontSize: 20),
            ),
            const Text('Ready to take the survey?'),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const SelectEducation()));
                },
                icon: const Icon(CupertinoIcons.arrow_right)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _genderController,
                decoration: const InputDecoration(label: Text('Enter Gender')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(label: Text('Enter Name')),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final userId = supabase.auth.currentUser!.id;
                  await supabase.from('profiles').update({
                    'gender': _genderController.text,
                    'full_name': _nameController.text
                  }).eq('id', userId);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Saved')));
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
