import 'package:flutter/material.dart';
import 'package:tekflat_design/tekflat_design.dart';

class BadgeText extends StatelessWidget {
  final String text;
  final Color color;

  const BadgeText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: TekCorners().mainCornerBorder,
          color: color,
        ),
        padding: EdgeInsets.all(TekSpacings().p6),
        child: TekTypography(text: text, type: TekTypographyType.body));
  }
}
