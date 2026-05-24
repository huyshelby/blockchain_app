import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'config.dart';
import 'marketplace_abi.dart';

class MarketplaceService {
  late Web3Client _client;
  late DeployedContract _contract;
  late EthPrivateKey _credentials;

  MarketplaceService() {
    _client = Web3Client(rpcUrl, Client());
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    _contract = DeployedContract(
      ContractAbi.fromJson(marketplaceAbi, 'Marketplace'),
      contractAddr,
    );
    _credentials = EthPrivateKey.fromHex(sellerPrivateKey);
  }

  void switchAccount(String privateKey) {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  EthereumAddress get currentAddress => _credentials.address;

  Future<EtherAmount> getBalance() async {
    return _client.getBalance(currentAddress);
  }

  Future<BigInt> getNextProductId() async {
    final result = await _client.call(
      contract: _contract,
      function: _contract.function('nextProductId'),
      params: [],
    );
    return result[0] as BigInt;
  }

  Future<Map<String, dynamic>> getProduct(BigInt productId) async {
    final result = await _client.call(
      contract: _contract,
      function: _contract.function('getProduct'),
      params: [productId],
    );
    final product = result[0];
    return {
      'id': product[0] as BigInt,
      'seller': (product[1] as EthereumAddress).hexEip55,
      'metadataURI': product[2] as String,
      'price': product[3] as BigInt,
      'active': product[4] as bool,
    };
  }

  Future<Map<String, dynamic>> getOrder(BigInt orderId) async {
    final result = await _client.call(
      contract: _contract,
      function: _contract.function('getOrder'),
      params: [orderId],
    );
    final order = result[0];
    return {
      'id': order[0] as BigInt,
      'productId': order[1] as BigInt,
      'buyer': (order[2] as EthereumAddress).hexEip55,
      'seller': (order[3] as EthereumAddress).hexEip55,
      'amount': order[4] as BigInt,
      'status': (order[5] as BigInt).toInt(),
    };
  }

  Future<String> createProduct(String metadataURI, BigInt price) async {
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _contract.function('createProduct'),
        parameters: [metadataURI, price],
      ),
      chainId: 31337,
    );
    return tx;
  }

  Future<String> buyProduct(BigInt productId, BigInt price) async {
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _contract.function('buyProduct'),
        parameters: [productId],
        value: EtherAmount.inWei(price),
      ),
      chainId: 31337,
    );
    return tx;
  }

  Future<String> markShipped(BigInt orderId) async {
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _contract.function('markShipped'),
        parameters: [orderId],
      ),
      chainId: 31337,
    );
    return tx;
  }

  Future<String> completeOrder(BigInt orderId) async {
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _contract.function('completeOrder'),
        parameters: [orderId],
      ),
      chainId: 31337,
    );
    return tx;
  }

  Future<String> withdraw() async {
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _contract.function('withdraw'),
        parameters: [],
      ),
      chainId: 31337,
    );
    return tx;
  }

  Future<BigInt> getWithdrawableBalance(String address) async {
    final result = await _client.call(
      contract: _contract,
      function: _contract.function('withdrawableBalance'),
      params: [EthereumAddress.fromHex(address)],
    );
    return result[0] as BigInt;
  }

  void dispose() {
    _client.dispose();
  }
}
