import 'package:flutter/material.dart';
import 'package:tekflat_design/tekflat_design.dart';

class LoadingWidget extends StatelessWidget {
  final String? title;

  const LoadingWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          TekTypography(
            text: title ?? "Loading",
            fontWeight: FontWeight.bold,
          ),
        ]));
  }
}
