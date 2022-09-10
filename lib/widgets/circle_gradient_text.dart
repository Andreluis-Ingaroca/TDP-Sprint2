import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';

class CircleGradientText extends StatelessWidget {
  final VoidCallback onTap;
  final String inCircleText;
  final MaterialColor color;
  final double? size, textSize;
  const CircleGradientText({
    Key? key,
    required this.onTap,
    required this.inCircleText,
    required this.color,
    this.textSize,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size ?? 70,
          height: size ?? 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 5,
                  offset: const Offset(2, 2))
            ],
            gradient: AppColors.getLinearGradient(color),
          ),
          child: Center(
            child: Text(
              inCircleText,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize ?? 17,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
