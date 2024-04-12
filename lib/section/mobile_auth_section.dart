import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:guard/service/state_service.dart';
import 'package:tekflat_design/tekflat_design.dart';

class MobileAuthSection extends StatefulWidget {
  final Function(AppState appState) setAppState;

  const MobileAuthSection({super.key, required this.setAppState});

  @override
  State<MobileAuthSection> createState() => _MobileAuthSection();
}

class _MobileAuthSection extends State<MobileAuthSection> {
  final LocalAuthentication auth = LocalAuthentication();
  
  bool? _didAuthenticate;
  PlatformException? _platformException;

  @override
  void initState() {
    super.initState();
  }

  void _skip() {
    widget.setAppState(AppState.retrieveSession);
  }

  void _auth() async {
    bool? didAuthenticate;
    PlatformException? platformException;
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to enable secure features.',
        options: const AuthenticationOptions(),
      );
      widget.setAppState(AppState.retrieveSession);
    } on PlatformException catch (e) {
      platformException = e;
    }

    setState(() {
      _platformException = platformException;
      _didAuthenticate = didAuthenticate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          TekVSpace.p18,
          TekButton(
            onPressed: _auth,
            text: 'Mobile Authentificate',
            width: double.infinity,
            type: TekButtonType.outline,
          ),
          TekVSpace.p18,
          TekButton(
            onPressed: _skip,
            text: 'Skip Mobile Authentificate',
            width: double.infinity,
            type: TekButtonType.outline,
          ),
        ]));
  }
}
