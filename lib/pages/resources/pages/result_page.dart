import 'package:career_counsellor/pages/resources/widgets/score_circle.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.currScore});
  final int currScore;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: screenHeight * 0.05,
              // ),
              Center(child: ScoreCircle(currScore: currScore)),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.06),
                      color: Colors.grey[900]),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.pink,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '100%',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text('Completion',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '9',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text('Correct',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.pink,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '10',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text('Total Questions',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.red[600]!,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '01',
                                    style: TextStyle(
                                        color: Colors.red[600]!,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text('Wrong',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: screenHeight * 0.1,
              ),
            ],
          )),
    );
  }
}
