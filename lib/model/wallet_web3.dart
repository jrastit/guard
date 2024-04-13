import 'dart:convert';
import "package:hex/hex.dart";
import 'package:hans/model/network_web3.dart';
import 'dart:math'; //used for the random number generator
import 'package:hans/model/wallet.dart';
import 'package:hans/service/my_ether_amount.dart';
import 'package:web3dart/web3dart.dart';

/// Represents a network connection to a Web3 provider.

/// Represents a Web3 wallet.
class WalletWeb3 extends WalletMeta {
  EthPrivateKey wallet;

  static List<WalletWeb3> items = [];

  /// Creates a [WalletWeb3] instance with a randomly generated key.
  factory WalletWeb3.random() {
    Random rng = Random.secure();
    EthPrivateKey localWallet = EthPrivateKey.createRandom(rng);
    return WalletWeb3.fromETHPrivateKey(localWallet);
  }

  /// Creates a [WalletWeb3] instance from a private key.
  factory WalletWeb3.fromPrivateKey(String privateKey) {
    EthPrivateKey localWallet = EthPrivateKey.fromHex(privateKey);
    return WalletWeb3.fromETHPrivateKey(localWallet);
  }

  factory WalletWeb3.fromJSON(String content) {
    //TODO: Implement password protection
    //Wallet json_wallet = Wallet.fromJson(content, "password");
    var walletExport = jsonDecode(content);
    EthPrivateKey localWallet =
        EthPrivateKey.fromHex(walletExport['private_key']);
    return WalletWeb3.fromETHPrivateKey(localWallet);
  }

  factory WalletWeb3.fromETHPrivateKey(EthPrivateKey ethPrivateKey) {
    WalletWeb3 wallet =
        WalletWeb3(address: ethPrivateKey.address.hex, wallet: ethPrivateKey);
    items.add(wallet);
    return wallet;
  }

  static WalletWeb3? fromAddress(String address) {
    for (var item in items) {
      if (item.address == address) {
        return item;
      }
    }
    return null;
  }

  WalletWeb3({
    required super.address,
    required this.wallet,
    super.type = WalletType.app,
  });

  export() {
    //Wallet walletExport = Wallet.createNew(_wallet, "password", Random());
    var walletExport = {'private_key': HEX.encode(wallet.privateKey)};
    return jsonEncode(walletExport);
  }

  /// Sends an ETH transaction from the wallet to the specified address.
  sendETHTransaction(String to, String amount) {
    return NetworkWeb3.defaultNetwork().ethClient.sendTransaction(
        wallet,
        Transaction(
          to: EthereumAddress.fromHex(to),
          value: MyEtherAmount.fromStringUnit(EtherUnit.ether, amount),
        ),
        chainId: 1337,
        fetchChainIdFromNetworkId: false);
  }
}
