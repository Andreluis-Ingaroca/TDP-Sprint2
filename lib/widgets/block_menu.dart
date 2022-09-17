import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';

class BlockMenuContainer extends StatelessWidget {
  final MaterialColor color;
  final VoidCallback? onTap;
  final bool? isSmall;
  final IconData icon;
  final String blockTittle;
  final String? blockSubLabel;
  const BlockMenuContainer({
    Key? key,
    required this.color,
    this.isSmall = false,
    required this.icon,
    required this.blockTittle,
    this.blockSubLabel = '',
    this.onTap, //remove from Explorar, Insignias
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color[400],
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 4,
                offset: const Offset(2, 6),
              )
            ],
            gradient: AppColors.getDarkLinearGradient(color),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: isSmall! ? Alignment.centerLeft : Alignment.center,
                child: Icon(
                  icon,
                  size: isSmall! ? 60 : 120,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                blockTittle,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                blockSubLabel!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
