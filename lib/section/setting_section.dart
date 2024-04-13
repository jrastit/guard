import 'package:flutter/material.dart';
import 'package:hans/action/test_action.dart';
import 'package:hans/action/user_action.dart';
import 'package:hans/model/user.dart';
import 'package:hans/model/wallet.dart';
import 'package:hans/service/http_handler.dart';
import 'package:hans/service/state_service.dart';
import 'package:hans/service/wallet_storage.dart';
import 'package:hans/widget/user_widget.dart';
import 'package:tekflat_design/tekflat_design.dart';

class SettingSection extends StatefulWidget {
  final Function setUser;
  final Function(AppState appState) setAppState;
  final User? user;
  final List<WalletMeta>? wallets;
  final Function setWallets;
  const SettingSection(
      {super.key,
      required this.user,
      required this.setUser,
      required this.wallets,
      required this.setWallets,
      required this.setAppState});

  @override
  State<SettingSection> createState() => _SettingSection();
}

class _SettingSection extends State<SettingSection> {
  Map<String, DateTime?>? _cookies;

  void logout() async {
    var user = await UserAction.logoutExec();
    HttpHandler.clearCookies();
    widget.setUser(user);
    widget.setAppState(isMobile ? AppState.biometric : AppState.login);
  }

  void deleteAccount() async {
    var user = await TestAction.deleteUserExec();
    HttpHandler.clearCookies();
    widget.setUser(user);
    widget.setAppState(isMobile ? AppState.biometric : AppState.login);
  }

  void deleteWallet() async {
    var user = await TestAction.deleteWalletExec();
    widget.setWallets(<WalletMeta>[]);
    widget.setUser(user);
    widget.setAppState(AppState.retrieveWallet);
  }

  void deleteLocalWallet() async {
    WalletStorage.deleteAllWallet();
    widget.setWallets(<WalletMeta>[]);
    widget.setAppState(AppState.retrieveWallet);
  }

  @override
  void initState() {
    super.initState();
    retrieveCookieInfo();
  }

  void retrieveCookieInfo() {
    HttpHandler.cookieHandler?.getCookieinfo().then((value) {
      setState(() {
        _cookies = value;
      });
    });
  }

  List<String> getCookieString() {
    if (_cookies == null || _cookies!.isEmpty) {
      return [];
    }
    List<String> rawCookies = [];
    _cookies!.forEach((key, value) {
      if (value == null) {
        rawCookies.add(key);
      } else if (value.isAfter(DateTime.now())) {
        rawCookies.add("$key : ${value.toIso8601String()}");
      } else {
        rawCookies.add("$key : expired}");
      }
    });
    return rawCookies;
  }

  @override
  Widget build(BuildContext context) {
    List<String> cookiesString = getCookieString();

    return SingleChildScrollView(
        child: Center(
            child: SizedBox(
      width: 350,
      // Your widget UI code here
      child: Column(
        children: [
          TekVSpace.mainSpace,
          if (isMobile)
            TekButton(
              onPressed: () {
                widget.setAppState(AppState.biometric);
              },
              width: double.infinity,
              type: TekButtonType.primary,
              text: 'Lock App',
            ),
          TekVSpace.mainSpace,
          if (widget.user != null)
            TekButton(
              onPressed: logout,
              width: double.infinity,
              type: TekButtonType.primary,
              text: 'Logout',
            ),
          TekVSpace.mainSpace,
          if (widget.user != null)
            TekButton(
              onPressed: deleteAccount,
              width: double.infinity,
              type: TekButtonType.primary,
              text: 'Delete Account (for test only!)',
            ),
          TekVSpace.mainSpace,
          if (widget.wallets != null && widget.wallets!.isNotEmpty)
            TekButton(
              onPressed: deleteWallet,
              width: double.infinity,
              type: TekButtonType.primary,
              text: 'Delete Remote Wallet (for test only!)',
            ),
          TekVSpace.mainSpace,
          if (widget.wallets != null && widget.wallets!.isNotEmpty)
            TekButton(
              onPressed: deleteLocalWallet,
              width: double.infinity,
              type: TekButtonType.primary,
              text: 'Delete Local Wallet (for test only!)',
            ),
          TekVSpace.mainSpace,
          if (widget.user != null) UserWidget(user: widget.user!),
          TekVSpace.mainSpace,
          if (cookiesString.isNotEmpty)
            const TekTypography(
              text: 'Cookies',
              type: TekTypographyType.titleLarge,
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: cookiesString.length,
            itemBuilder: (context, index) {
              return TekTypography(
                text: cookiesString[index],
              );
            },
          ),
        ],
      ),
    )));
  }
}
