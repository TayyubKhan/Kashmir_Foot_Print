import 'package:flutter/material.dart';

import '../Utilis/colors.dart';

class AppButton extends StatelessWidget {
  bool loading;
  final String text;
  final VoidCallback onTap;
  AppButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.06,
        width: width * 0.6,
        decoration:
            BoxDecoration(color: back, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
