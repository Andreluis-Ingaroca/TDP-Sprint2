import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    this.onTap,
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

class TinyBlockContainer extends StatelessWidget {
  final Color color;
  final String image;
  final String blockTittle;

  const TinyBlockContainer({super.key, required this.color, required this.image, required this.blockTittle});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0.2,
            //   offset: const Offset(2, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => SpinKitFadingCube(
            color: AppColors.customPurple,
            size: 30,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
