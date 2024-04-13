import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:hans/action/base_action.dart';
import 'package:hans/model/wallet.dart';
import 'package:hans/service/http_handler.dart';

var logger = Logger();

http.Client client = http.Client();

class WalletAction {
  static Future<WalletMeta?> walletCustodial() async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/wallet/wallet");
    if (ret == null) {
      return null;
    }
    return WalletMeta.fromJson(ret);
  }

  static Future<List<WalletMeta>> walletList() async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/wallet/list");
    if (ret == null) {
      return [];
    }
    List<WalletMeta> wallets = [];
    List<dynamic> walletJson = ret['wallet_list'] as List<dynamic>;
    for (var item in walletJson) {
      WalletMeta wallet = WalletMeta.fromJson(item);
      wallets.add(wallet);
    }
    return wallets;
  }
}
