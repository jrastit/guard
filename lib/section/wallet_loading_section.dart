import 'package:flutter/material.dart';
import 'package:hans/action/wallet_action.dart';
import 'package:hans/model/wallet.dart';
import 'package:hans/service/state_service.dart';
import 'package:hans/service/wallet_storage.dart';
import 'package:hans/widget/loading_widget.dart';

class LoadingWalletSection extends StatefulWidget {
  final Function setWallets;
  final Function(AppState appState) setAppState;
  final List<WalletMeta>? wallets;

  const LoadingWalletSection(
      {super.key,
      required this.wallets,
      required this.setWallets,
      required this.setAppState});

  @override
  State<LoadingWalletSection> createState() => _LoadingWalletSection();
}

class _LoadingWalletSection extends State<LoadingWalletSection> {
  void _load() async {
    List<WalletMeta> wallets = [];
    List<WalletMeta> loadedWallet =
        await WalletStorage.loadItemsFromSecureStorage();
    List<WalletMeta> remoteWallets = await WalletAction.walletList();
    wallets.addAll(loadedWallet);
    wallets.addAll(remoteWallets);
    widget.setWallets(wallets);
    widget.setAppState(AppState.wallet);
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
    return const LoadingWidget(title: "Loading wallets...");
  }
}
