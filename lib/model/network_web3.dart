import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class NetworkWeb3 {
  Web3Client ethClient;

  static String apiUrl =
      "https://geonft.fexhu.com/ganache/"; //Replace with your API

  static Client httpClient = Client();

  /// Creates a [NetworkWeb3] instance with the default network configuration.
  factory NetworkWeb3.defaultNetwork() {
    return NetworkWeb3(Web3Client(NetworkWeb3.apiUrl, NetworkWeb3.httpClient));
  }

  NetworkWeb3(this.ethClient);
}
