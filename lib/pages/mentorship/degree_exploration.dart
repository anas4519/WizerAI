import 'package:flutter/material.dart';

class DegreeExplorationPage extends StatefulWidget {
  const DegreeExplorationPage({Key? key}) : super(key: key);

  @override
  State<DegreeExplorationPage> createState() => _DegreeExplorationPageState();
}

class _DegreeExplorationPageState extends State<DegreeExplorationPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";

  // Sample degree data
  final List<Map<String, dynamic>> _degrees = [
    {
      'name': 'Computer Science',
      'category': 'Technology',
      'duration': '4 years',
      'description':
          'Study of computers and computational systems, including programming, algorithms, and software development.',
      'careers': ['Software Developer', 'Data Scientist', 'Systems Analyst'],
      'icon': Icons.computer,
    },
    {
      'name': 'Business Administration',
      'category': 'Business',
      'duration': '4 years',
      'description':
          'Study of business operations, management, and strategy to prepare for leadership roles.',
      'careers': ['Business Manager', 'Entrepreneur', 'Consultant'],
      'icon': Icons.business,
    },
    {
      'name': 'Psychology',
      'category': 'Social Sciences',
      'duration': '4 years',
      'description':
          'Study of human behavior and mental processes, exploring cognitive, emotional, and social aspects.',
      'careers': ['Psychologist', 'Counselor', 'Human Resources'],
      'icon': Icons.psychology,
    },
    {
      'name': 'Mechanical Engineering',
      'category': 'Engineering',
      'duration': '4 years',
      'description':
          'Design and analysis of mechanical systems, from machines to energy systems.',
      'careers': ['Mechanical Engineer', 'Product Designer', 'Project Manager'],
      'icon': Icons.engineering,
    },
    {
      'name': 'Nursing',
      'category': 'Healthcare',
      'duration': '4 years',
      'description':
          'Training in patient care, health promotion, and disease prevention.',
      'careers': [
        'Registered Nurse',
        'Nurse Practitioner',
        'Healthcare Administrator'
      ],
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Graphic Design',
      'category': 'Arts',
      'duration': '4 years',
      'description':
          'Visual communication and problem-solving through typography, imagery, and various design elements.',
      'careers': ['Graphic Designer', 'UI/UX Designer', 'Art Director'],
      'icon': Icons.design_services,
    },
  ];

  // Categories for filtering
  final List<String> _categories = [
    "All",
    "Technology",
    "Business",
    "Social Sciences",
    "Engineering",
    "Healthcare",
    "Arts"
  ];

  List<Map<String, dynamic>> get _filteredDegrees {
    if (_selectedFilter == "All") {
      return _searchController.text.isEmpty
          ? _degrees
          : _degrees
              .where((degree) => degree['name']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
    } else {
      return _degrees
          .where((degree) =>
              degree['category'] == _selectedFilter &&
              (_searchController.text.isEmpty ||
                  degree['name']
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())))
          .toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFFF4081); // Pink color
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Degrees'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search degrees...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                // Category filters
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedFilter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = category;
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.8),
                          selectedColor: Colors.white,
                          checkmarkColor: primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Degree cards
          Expanded(
            child: _filteredDegrees.isEmpty
                ? Center(
                    child: Text(
                      'No degrees found',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredDegrees.length,
                    itemBuilder: (context, index) {
                      final degree = _filteredDegrees[index];
                      return DegreeCard(
                        degree: degree,
                        primaryColor: primaryColor,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show interests quiz or recommendation feature
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Degree recommendation quiz coming soon!')));
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.auto_awesome),
        tooltip: 'Find degrees that match your interests',
      ),
    );
  }
}

class DegreeCard extends StatelessWidget {
  final Map<String, dynamic> degree;
  final Color primaryColor;
  final bool isDarkMode;

  const DegreeCard({
    Key? key,
    required this.degree,
    required this.primaryColor,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.2),
          child: Icon(
            degree['icon'] as IconData,
            color: primaryColor,
          ),
        ),
        title: Text(
          degree['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${degree['category']} • ${degree['duration']}',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            degree['description'],
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Career opportunities
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Career Opportunities:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (degree['careers'] as List).map((career) {
                  return Chip(
                    label: Text(
                      career,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: isDarkMode
                        ? primaryColor.withOpacity(0.3)
                        : primaryColor.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DummyDegreeDetailPage(degree: degree),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}

// Dummy page for demonstration purposes
class DummyDegreeDetailPage extends StatelessWidget {
  final Map<String, dynamic> degree;

  const DummyDegreeDetailPage({Key? key, required this.degree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(degree['name']),
      ),
      body: Center(
        child: Text(
            'Detailed information about ${degree["name"]} would appear here.'),
      ),
    );
  }
}
