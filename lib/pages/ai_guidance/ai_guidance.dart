import 'package:career_counsellor/auth/auth_service.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_details.dart';
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
  List<String> daimonSuggestions = [];
  bool _isLoading = true;
  String name = 'User';

  void logout() async {
    await authService.signOut();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();

      setState(() {
        name = data['full_name'] ?? 'User';
        daimonSuggestions = data['suggestions'] != null
            ? (data['suggestions'] as List<dynamic>)
                .map((e) => e.toString())
                .toList()
            : _getDefaultSuggestions();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        name = 'User';
        daimonSuggestions = _getDefaultSuggestions();
        _isLoading = false;
      });
    }
  }

  List<String> _getDefaultSuggestions() {
    return [
      'Software Engineering',
      'Data Science',
      'Digital Marketing',
      'UX/UI Design',
      'Product Management'
    ];
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Guidance', style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
          : daimonSuggestions.isEmpty
              ? _buildEmptyStateWidget(context)
              : _buildSuggestionsListWidget(context, screenWidth, screenHeight),
    );
  }

  Widget _buildEmptyStateWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello $name!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'It looks like we don\'t have any career suggestions for you yet.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SelectEducation()),
                );
              },
              icon: const Icon(CupertinoIcons.arrow_right),
              label: const Text('Take Career Survey'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsListWidget(
      BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi $name, here are your career suggestions:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: daimonSuggestions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.02),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 20,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      daimonSuggestions[index],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => CareerDetails(
                                    title: daimonSuggestions[index],
                                  )));
                        },
                        icon: const Icon(Icons.arrow_forward_rounded)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
