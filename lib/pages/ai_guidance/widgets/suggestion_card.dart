import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CareerSuggestionCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String cta;

  const CareerSuggestionCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.cta,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: InkWell(
        onTap: () {
          // Handle card tap
        },
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Row(
            children: [
              FancyShimmerImage(
                imageUrl: image,
                errorWidget: const Icon(Icons.error),
                width: 150,
                height: 100,
              ),
              // CachedNetworkImage(
              //   imageUrl: icon,
              //   width: 100,
              //   height: 100,
              //   placeholder: (context, url) =>
              //       const Center(child: CircularProgressIndicator()),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
              SizedBox(width: screenWidth*0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.005),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth*0.01),
              IconButton(
                onPressed: () {
                  // Handle CTA button tap
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
