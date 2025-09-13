import 'package:ayurvedic_centre_app/core/util/app_color.dart';
import 'package:ayurvedic_centre_app/core/util/common_widgets.dart';
import 'package:ayurvedic_centre_app/core/util/sized_box.dart';
import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onTap;

  const StatusView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = Colors.grey,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizeBoxH(130),
            Icon(icon, size: 100, color: iconColor),
            SizeBoxH(30),
            text(text: title, size: 20, fontWeight: FontWeight.w600),
            SizeBoxH(10),
            text(
              text: subtitle,
              size: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.black.withOpacity(0.6),
              textAlign: TextAlign.center,
            ),
            SizeBoxH(30),
            // button(name: buttonText, height: 45, width: 160, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
