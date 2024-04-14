import 'package:hans/model/nft.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:hans/action/base_action.dart';
import 'package:hans/model/contract.dart';
import 'package:hans/service/http_handler.dart';

var logger = Logger();

http.Client client = http.Client();

class ContractAction {
  static Future<List<Contract>> loadContracts() async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/h3/list");
    if (ret == null) {
      return [];
    }
    List<Contract> contracts = [];
    for (var c in ret['contracts']) {
      contracts.add(Contract.fromJson(c));
    }
    return contracts;
  }

  static Future<Contract?> createContractExec(String address, String community, String communitySymbol, bool isPublic, bool isOpen, int h3Price) async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/h3/contract", {
      'address': address,
      'community': community,
      'communitySymbol': communitySymbol,
      'isPublic': isPublic,
      'isOpen': isOpen,
      'h3Price': h3Price,
    });
    if (ret == null) {
      return null;
    }
    return Contract.fromJson(ret['contract']);
  }

  static Future<List<NFT>> loadNFTs(address, latitud, longitud, level, contractId) async {
    var ret = await HttpHandler.postAuth("${getBaseUrl()}/h3/h3",
        {'address': address, 'latitud': latitud, 'longitud': longitud, 'level': level, 'contract': contractId}
    );
    if (ret == null) {
      return [];
    }
    List<NFT> nfts = [];
    logger.d(ret);
    for (var n in ret['nfts']) {
      nfts.add(NFT.fromJson(n));
    }
    return nfts;
  }

  static Future<void> createNFTExec(String address, String name, String description, String imageURI, latitud, longitud, String contract) async {
    try {
      var ret = await HttpHandler.postAuth("${getBaseUrl()}/h3/nft", {
        'name': name,
        'description': description,
        'imageURI': imageURI,
        'longitud': longitud,
        'latitud': latitud,
        'contract': contract,
        'level_min': 1,
        'level_max': 8,
      });
      if (ret == null) {
        logger.e("error null");
        return;
      }
      return;
    } catch (e) {
      logger.e("error $e");
      throw Exception("$e");

    }
  }
}

