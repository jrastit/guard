import 'package:flutter/material.dart';
import 'package:guard/action/user_action.dart';
import 'package:guard/model/user.dart';
import 'package:guard/service/state_service.dart';
import 'package:guard/widget/loading_widget.dart';

class LoadingSessionSection extends StatefulWidget {
  final Function setUser;
  final Function(AppState appState) setAppState;
  final User? user;

  const LoadingSessionSection(
      {super.key,
      required this.user,
      required this.setUser,
      required this.setAppState});

  @override
  State<LoadingSessionSection> createState() => _LoadingSessionSection();
}

class _LoadingSessionSection extends State<LoadingSessionSection> {
  void _load() async {
    User? user = await UserAction.loadSessionUser();
    widget.setUser(user);
    if (user != null) {
      widget.setAppState(AppState.retrieveWallet);
    } else {
      widget.setAppState(AppState.login);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingWidget(title: "Loading session...");
  }
}
