import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guard/action/test_action.dart';
import 'package:guard/widget/badge_test.dart';
import 'package:tekflat_design/tekflat_design.dart';

class ServerStatus extends StatefulWidget {
  const ServerStatus({super.key});

  @override
  State<ServerStatus> createState() => _ServerStatus();
}

class _ServerStatus extends State<ServerStatus> {
  bool? _serverStatus;
  Timer? timer;

  void checkStatus() {
    TestAction.pingExec().then((value) {
      setState(() => _serverStatus = value);
    }).catchError((err) {
      setState(() {
        _serverStatus = false;
      });
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_serverStatus == null) {
      return BadgeText(text: "Checking server", color: TekColors().blue);
    }
    if (_serverStatus == false) {
      return BadgeText(text: "Server error", color: TekColors().red);
    }
    return BadgeText(text: "Server ok", color: TekColors().green);
  }
}
