import 'package:hans/model/network_web3.dart';
import 'package:web3dart/web3dart.dart';

enum WalletType {
  custodial,
  app,
  metamask,
}

class WalletMeta {
  int id;

  String address;

  WalletType type;

  String? walletId;

  DateTime? createdAt;
  DateTime? updatedAt;

  WalletMeta(
      {required this.address,
      required this.type,
      this.walletId,
      this.id = 0,
      this.createdAt,
      this.updatedAt
      }
      );

  factory WalletMeta.fromJson(Map<String, dynamic> json) {
    return WalletMeta(
      id: int.parse(json['id'] ?? '0'),
      address: json['address'] ?? '',
      type: WalletType.values[json['type'] ?? WalletType.custodial],
      walletId: json['walletId'],
      createdAt: DateTime.parse(json['time'] ?? ''),
      updatedAt: DateTime.parse(json['lastTime'] ?? ''),
    );
  }

  /// Retrieves the balance of the wallet.
  balance() {
    return NetworkWeb3.defaultNetwork()
        .ethClient
        .getBalance(EthereumAddress.fromHex(address));
  }
}
