import 'package:hans/model/network_web3.dart';
import 'package:web3dart/web3dart.dart';

enum WalletType {
  dfns,
  app,
  metamask,
}

class WalletMeta {
  int id;

  String address;

  WalletType type;

  String? walletId;

  String time;
  String lastTime;

  WalletMeta(
      {required this.address,
      required this.type,
      this.walletId,
      this.id = 0,
      this.lastTime = '',
      this.time = ''});

  factory WalletMeta.fromJson(Map<String, dynamic> json) {
    return WalletMeta(
      id: json['id'] ?? 0,
      address: json['address'] ?? '',
      type: WalletType.values[json['type'] ?? 0],
      walletId: json['walletId'],
      time: json['time'] ?? '',
      lastTime: json['lastTime'] ?? '',
    );
  }

  /// Retrieves the balance of the wallet.
  balance() {
    return NetworkWeb3.defaultNetwork()
        .ethClient
        .getBalance(EthereumAddress.fromHex(address));
  }
}
