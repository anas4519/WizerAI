import 'package:career_counsellor/pages/career_exploration/screens/career_details.dart';
import 'package:career_counsellor/pages/career_exploration/screens/search_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareerExploration extends StatefulWidget {
  const CareerExploration({super.key});

  @override
  State<CareerExploration> createState() => _CareerExplorationState();
}

class _CareerExplorationState extends State<CareerExploration> {
  int _current = 0;
  List<String> daimonSuggestions = [];
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = true;

  @override
  void initState() {
    fetchSuggestions();
    super.initState();
  }

  Future<void> fetchSuggestions() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from('profiles').select().eq('id', userId).single();

      setState(() {
        daimonSuggestions = data['suggestions'] != null
            ? (data['suggestions'] as List<dynamic>).map((e) => e.toString()).toList()
            : _getDefaultSuggestions();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
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

  final List<Map<String, String>> careerDetails = [
    {
      'image': 'assets/career_images/career_1.png',
      'title': 'Software Development',
      'description': 'Explore the world of coding and software development',
    },
    {
      'image': 'assets/career_images/career_2.png',
      'title': 'Teaching',
      'description': 'Analyze data and derive meaningful insights',
    },
    {
      'image': 'assets/career_images/career_3.png',
      'title': 'Neurobiology',
      'description': 'Master the art of online marketing and growth',
    },
    {
      'image': 'assets/career_images/career_4.png',
      'title': 'Healthcare',
      'description': 'Create beautiful and functional user experiences',
    },
    {
      'image': 'assets/career_images/career_5.png',
      'title': 'Financial Analysis',
      'description': 'Lead product development and innovation',
    },
  ];

  void _handleImageTap(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            CareerDetails(title: careerDetails[index]['title']!)));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final screenwidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SearchScreen()));
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(screenwidth * 0.02),
              child: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenwidth * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore new possibilities and take the first step today!',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      color: isDarkTheme
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              const Text(
                'Trending',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              CarouselSlider.builder(
                itemCount: careerDetails.length,
                itemBuilder: (context, index, realIndex) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenwidth * 0.025),
                    child: GestureDetector(
                      onTap: () => _handleImageTap(index),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                careerDetails[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  careerDetails[index]['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 0.9,
                  height: screenHeight * 0.25,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: careerDetails.asMap().entries.map((entry) {
                  return Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: isDarkTheme ? Colors.white : Colors.black),
                      shape: BoxShape.circle,
                      color: Colors.pink
                          .withOpacity(_current == entry.key ? 0.9 : 0.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                'Daimon Suggestions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              // Generate ListTiles dynamically
              ...List.generate(5, (index) {
                return ListTile(
                  leading: Text(
                    '${index + 1}. ',
                    style: const TextStyle(fontSize: 16),
                  ),
                  title: Text(
                    daimonSuggestions[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => CareerDetails(title: daimonSuggestions[index]),
                    ));
                  },
                );
              }),
            ],
          ),
        ));
  }
}