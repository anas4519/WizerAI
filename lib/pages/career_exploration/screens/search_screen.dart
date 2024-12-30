import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_details.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> displayList = [];

  @override
  void initState() {
    super.initState();
    displayList = Constants.popularCareers;
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displayList = Constants.popularCareers;
      } else {
        displayList = Constants.popularCareers
            .where(
                (career) => career.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.005),
            Row(
              children: [
                const Text(
                  'Search for a Profession',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Uncomment and implement the showDialog if needed
                  },
                  icon: const Icon(Icons.info),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                border: Border.all(color: Colors.pink, width: 2),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded, color: Colors.pink),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => updateList(value),
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for career...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Expanded(
              child: displayList.isEmpty
                  ? ListTile(
                      title: const Text(
                          "Didn't find what you were looking for? Click here after you finish typing the career name."),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) =>
                                CareerDetails(title: _searchController.text)));
                      },
                    )
                  : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(displayList[index]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    CareerDetails(title: displayList[index])));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
