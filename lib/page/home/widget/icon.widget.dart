import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final bool? isHaveCount;
  final String? total;
  const IconWidget(
      {super.key,
      required this.onTap,
      required this.iconPath,
      this.isHaveCount = false,
      this.total = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(iconPath),
            if (isHaveCount!)
              Positioned(
                top: -5,
                left: -5,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6342E8),
                    borderRadius: BorderRadius.circular(17 * 2),
                  ),
                  child: Center(
                    child: Text(
                      total!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
