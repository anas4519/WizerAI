import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline,
              size: 20, color: Theme.of(context).primaryColor),
          SizedBox(width: screenWidth * 0.02),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              // overflow: TextOverflow.ellipsis,
              // maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
