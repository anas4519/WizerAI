import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data - in a real app, this would come from a database or API
  final Map<String, dynamic> userData = {
    'name': 'Jane Doe',
    'email': 'jane.doe@example.com',
    'phone': '+1 (555) 123-4567',
    'location': 'New York, NY',
    'avatar': 'https://i.pravatar.cc/150?img=1',
    'education': [
      {
        'degree': 'Master of Computer Science',
        'institution': 'Stanford University',
        'year': '2020-2022'
      },
      {
        'degree': 'Bachelor of Engineering',
        'institution': 'MIT',
        'year': '2016-2020'
      }
    ],
    'additionalInfo': {
      'languages': ['English', 'Spanish', 'French'],
      'skills': ['Flutter', 'React', 'Python', 'UI/UX Design'],
      'interests': ['Photography', 'Hiking', 'Reading']
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAvatarSection(context),
            _buildBasicDetailsSection(context),
            _buildEducationSection(context),
            _buildAdditionalDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final avatarBgColor = isDarkMode
        ? primaryColor.withOpacity(0.2)
        : primaryColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: avatarBgColor,
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userData['avatar']),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              userData['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userData['location'],
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDetailsSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'Basic Details',
      icon: Icons.person,
      children: [
        _buildDetailRow(context, Icons.email, 'Email', userData['email']),
        _buildDetailRow(context, Icons.phone, 'Phone', userData['phone']),
        _buildDetailRow(
            context, Icons.location_city, 'Location', userData['location']),
      ],
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    List<Widget> educationWidgets = userData['education'].map<Widget>((edu) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              edu['degree'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(edu['institution']),
            Text(
              edu['year'],
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }).toList();

    return _buildSection(
      context: context,
      title: 'Education',
      icon: Icons.school,
      children: educationWidgets,
    );
  }

  Widget _buildAdditionalDetailsSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'Additional Details',
      icon: Icons.more_horiz,
      children: [
        _buildChipList(
            context, 'Languages', userData['additionalInfo']['languages']),
        const SizedBox(height: 16),
        _buildChipList(context, 'Skills', userData['additionalInfo']['skills']),
        const SizedBox(height: 16),
        _buildChipList(
            context, 'Interests', userData['additionalInfo']['interests']),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;

    return Card(
      margin: const EdgeInsets.all(16),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipList(
      BuildContext context, String title, List<String> items) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Chip(
              backgroundColor: isDarkMode
                  ? primaryColor.withOpacity(0.2)
                  : primaryColor.withOpacity(0.1),
              label: Text(
                item,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
