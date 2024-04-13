import 'package:shared_preferences/shared_preferences.dart';
import 'package:hans/model/wallet_web3.dart';
import 'package:hans/service/storage_handler.dart';

class WalletStorage {
  static WalletWeb3? wallet;

  static getLocalStorage() async {
    return await SharedPreferences.getInstance();
  }

  static Future<List<WalletWeb3>> loadItemsFromSecureStorage() async {
    List<WalletWeb3> items = [];
    SharedPreferences localStorage = await getLocalStorage();
    Map<String, String> allValues = await secureStorageHandler.readAll();
    allValues.forEach((key, value) {
      if (key.startsWith("wallet_")) {
        items.add(WalletWeb3.fromJSON(value));
      }
    });
    String? address = localStorage.getString("address");
    WalletWeb3? wallet2;
    if (items.isNotEmpty) {
      for (var item in items) {
        if (item.address == address) {
          wallet2 = item;
          break;
        }
      }
    }
    wallet = wallet2;
    if (wallet == null && items.isNotEmpty) {
      wallet = items[0];
    }
    return items;
  }

  static Future<void> saveItemToSecureStorage(WalletWeb3 wallet) async {
    await secureStorageHandler.write(
        key: "wallet_${wallet.address}", value: wallet.export());
  }

  static void deleteAllWallet() async {
    Map<String, String> allValues = await secureStorageHandler.readAll();
    allValues.forEach((key, value) {
      if (key.startsWith("wallet_")) {
        secureStorageHandler.delete(key: key);
      }
    });
  }
}
