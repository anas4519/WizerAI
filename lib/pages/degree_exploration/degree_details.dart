import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/degree_exploration/utils/lists.dart';
import 'package:flutter/material.dart';

class DegreeDetails extends StatefulWidget {
  const DegreeDetails({super.key, required this.title, required this.idx});
  final String title;
  final int idx;

  @override
  State<DegreeDetails> createState() => _DegreeDetailsState();
}

class _DegreeDetailsState extends State<DegreeDetails> {
  bool isBachelorsSelected = true;
  bool isMastersSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMastersSelected = false;
                        isBachelorsSelected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isBachelorsSelected
                              ? Colors.pink
                              : Colors.transparent),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Bachelors'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMastersSelected = true;
                        isBachelorsSelected = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isMastersSelected
                              ? Colors.pink
                              : Colors.transparent),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Masters'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      isBachelorsSelected ? design[0].length : design[1].length,
                  itemBuilder: (context, index) {
                    final courseName = isBachelorsSelected
                        ? design[0][index]
                        : design[1][index];
                    return ListTile(
                      title: Text(courseName),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
