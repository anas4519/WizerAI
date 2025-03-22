import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';

class DegreeExplorationPage extends StatefulWidget {
  const DegreeExplorationPage({super.key});

  @override
  State<DegreeExplorationPage> createState() => _DegreeExplorationPageState();
}

class _DegreeExplorationPageState extends State<DegreeExplorationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Coming Soon!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Degree Exploration Page',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "We're working hard to bring you an amazing experience "
                  "to explore various degree programs. Stay tuned!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Notify Me When Ready'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    showNotificationSnackBar(context,
                        'You will be notified when the Degree Exploration Page is ready.');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
