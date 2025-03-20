import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userBox = Hive.box('user_box');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  userBox.get('full_name'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: userBox.get('avatar_url'),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showComingSoonSnackBar(
                        context, 'This feature will be available soon.');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    showComingSoonSnackBar(
                        context, 'This feature will be available soon.');
                  },
                ),
              ],
            ),

            // Content sections
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionWithTitle(
                      context,
                      'Education',
                      Icons.school,
                      Text(userBox.get('qualifications')),
                    ),
                    _buildSectionWithTitle(
                      context,
                      'Interests',
                      Icons.favorite,
                      _buildChipList(context, 'interests', Colors.orange),
                    ),

                    _buildSectionWithTitle(
                      context,
                      'Hobbies',
                      Icons.interests,
                      _buildChipList(context, 'hobbies', Colors.purple),
                    ),

                    // Skills section
                    _buildSectionWithTitle(
                      context,
                      'Skills',
                      Icons.code,
                      _buildChipList(context, 'skills', Colors.blue),
                    ),

                    // Strengths section
                    _buildSectionWithTitle(
                      context,
                      'Strengths',
                      Icons.fitness_center,
                      _buildChipList(context, 'strengths', Colors.green),
                    ),

                    if (userBox.get('weaknesses') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Weaknesses',
                            Icons.warning,
                            _buildChipList(context, 'weaknesses', Colors.grey),
                          ),
                        ],
                      ),

                    _buildSectionWithTitle(
                        context,
                        'Desired Lifestyle',
                        Icons.self_improvement,
                        Text(userBox.get('desired_lifestyle'))),

                    if (userBox.get('geographic_preferences') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Geographic Preferences',
                            Icons.public,
                            Text(userBox.get('geographic_preferences')),
                          ),
                        ],
                      ),

                    _buildSectionWithTitle(context, 'Learning Curve',
                        Icons.show_chart, Text(userBox.get('learning_curve'))),

                    if (userBox.get('aspirations') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Aspirations',
                            Icons.emoji_events,
                            Text(userBox.get('aspirations')),
                          ),
                        ],
                      ),

                    if (userBox.get('mothers_profession') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Mother\'s Profession',
                            Icons.woman,
                            Text(userBox.get('mothers_profession')),
                          ),
                        ],
                      ),

                    if (userBox.get('fathers_profession') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Father\'s Profession',
                            Icons.man,
                            Text(userBox.get('fathers_profession')),
                          ),
                        ],
                      ),

                    if (userBox.get('interdisciplinary_options') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Interdisciplinary Options',
                            Icons.menu_book,
                            Text(userBox.get('interdisciplinary_options')),
                          ),
                        ],
                      ),

                    _buildSectionWithTitle(
                        context,
                        'Financial Status',
                        Icons.account_balance,
                        Text(userBox.get('financial_status'))),

                    _buildSectionWithTitle(
                        context,
                        'Salary Expectations',
                        Icons.monetization_on,
                        Text(userBox.get('salary_expectations'))),

                    if (userBox.get('additional_information') != null)
                      Column(
                        children: [
                          _buildSectionWithTitle(
                            context,
                            'Additional Information',
                            Icons.description,
                            Text(userBox.get('additional_information')),
                          ),
                        ],
                      ),

                    // Languages section
                    // _buildSectionWithTitle(
                    //   context,
                    //   'Languages',
                    //   Icons.language,
                    //   _buildLanguagesList(
                    //       context, userData['languages'] as List<String>),
                    // ),
                    // const SizedBox(height: 24),

                    // // Interests section
                    // _buildSectionWithTitle(
                    //   context,
                    //   'Interests',
                    //   Icons.favorite,
                    //   _buildChipList(
                    //       context, userData['interests'] as List<String>),
                    // ),
                    // const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildBioSection(BuildContext context, Map<String, dynamic> userData) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'About',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           userData['bio'] as String,
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Theme.of(context)
  //                 .textTheme
  //                 .bodyLarge
  //                 ?.color
  //                 ?.withOpacity(0.8),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactSection(
  //     BuildContext context, Map<String, dynamic> userData) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).cardColor,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Icons.contact_mail),
  //             SizedBox(width: 8),
  //             Text(
  //               'Contact Information',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         _buildContactItem(
  //             context, Icons.email, 'Email', userBox.get('email') ?? 'lol'),
  //         const Divider(height: 16),
  //         _buildContactItem(
  //             context, Icons.phone, 'Phone', userData['phone'] as String),
  //         const Divider(height: 16),
  //         _buildContactItem(context, Icons.location_on, 'Location',
  //             userData['location'] as String),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactItem(
  //     BuildContext context, IconData icon, String label, String value) {
  //   return Row(
  //     children: [
  //       Icon(
  //         icon,
  //         size: 20,
  //         color: Theme.of(context).colorScheme.primary,
  //       ),
  //       const SizedBox(width: 16),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Theme.of(context)
  //                   .textTheme
  //                   .bodyMedium
  //                   ?.color
  //                   ?.withOpacity(0.6),
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               fontSize: 16,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSectionWithTitle(
      BuildContext context, String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
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
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  // Widget _buildEducationItems(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: educationList.map<Widget>((education) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               education['degree'] as String,
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               education['institution'] as String,
  //               style: TextStyle(
  //                 fontSize: 15,
  //                 color: Theme.of(context).colorScheme.primary,
  //               ),
  //             ),
  //             const SizedBox(height: 2),
  //             Text(
  //               education['year'] as String,
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Theme.of(context)
  //                     .textTheme
  //                     .bodyMedium
  //                     ?.color
  //                     ?.withOpacity(0.6),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildChipList(BuildContext context, String section, Color color) {
    List<String> items = userBox.get(section).split(',');

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Chip(
          label: Text(item),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(
            color: color.withOpacity(0.2),
          ),
          labelStyle: TextStyle(
            color: color,
          ),
        );
      }).toList(),
    );
  }
}
