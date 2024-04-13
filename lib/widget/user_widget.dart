import 'package:flutter/material.dart';
import 'package:hans/model/user.dart';
import 'package:tekflat_design/tekflat_design.dart';

class UserWidget extends StatelessWidget {
  final User user;

  const UserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TekTypography(
          text: 'You are connected as ${user.login}',
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
