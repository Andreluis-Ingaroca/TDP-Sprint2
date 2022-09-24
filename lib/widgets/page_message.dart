import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';

class PageMessage extends StatelessWidget {
  const PageMessage({
    Key? key,
    required this.messagePage,
    required this.iconPage,
  }) : super(key: key);

  final String messagePage;
  final IconData iconPage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconPage,
            size: 100,
            color: AppColors.customPurple,
          ),
          const SizedBox(height: 20),
          Text(
            messagePage,
            style: TextStyle(
              color: AppColors.customPurple,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
