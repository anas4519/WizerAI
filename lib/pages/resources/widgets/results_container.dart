import 'package:flutter/material.dart';

class ResultsContainer extends StatelessWidget {
  const ResultsContainer(
      {super.key,
      required this.completion,
      required this.total,
      required this.correct,
      required this.wrong});
  final int completion;
  final int total;
  final int correct;
  final int wrong;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$completion%',
                          style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const Text('Completion',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$correct',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const Text('Correct',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$total',
                          style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const Text('Total Questions',
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
                          '$wrong',
                          style: TextStyle(
                              color: Colors.red[600]!,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const Text('Wrong',
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
        ));
  }
}
