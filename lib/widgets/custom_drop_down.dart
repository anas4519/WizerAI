import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {super.key,
      required this.label,
      required this.list,
      required this.onChanged,
      required this.validationText});
  final String label;
  final List<String> list;
  final ValueChanged<String?> onChanged;
  final String validationText;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? standard;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
          borderSide: BorderSide(
            color: Theme.of(context)
                .primaryColor, // Change the border color when focused
            width: 2.0, // Adjust the width as needed
          ),
        ),
      ),
      // style: TextStyle(
      //   color: Colors.white, // Text color inside the dropdown
      //   fontSize: 16
      // ),
      value: standard,
      items: widget.list.map((String sector) {
        return DropdownMenuItem<String>(
          value: sector,
          child: Text(sector),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          standard = newValue!;
        });
        widget.onChanged(newValue);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your ${widget.validationText}.';
        }
        return null;
      },
    );
  }
}
