import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import '../marketplace_service.dart';
import '../config.dart';

class WalletState {
  final bool isSeller;
  final EthereumAddress address;
  final EtherAmount? balance;
  final BigInt? withdrawable;
  final bool isLoading;

  const WalletState({
    required this.isSeller,
    required this.address,
    this.balance,
    this.withdrawable,
    this.isLoading = false,
  });

  WalletState copyWith({
    bool? isSeller,
    EthereumAddress? address,
    EtherAmount? balance,
    BigInt? withdrawable,
    bool? isLoading,
  }) {
    return WalletState(
      isSeller: isSeller ?? this.isSeller,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      withdrawable: withdrawable ?? this.withdrawable,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  String get truncatedAddress {
    final hex = address.hexEip55;
    return '${hex.substring(0, 6)}...${hex.substring(hex.length - 4)}';
  }

  String get balanceFormatted {
    if (balance == null) return '...';
    return '${balance!.getValueInUnit(EtherUnit.ether).toStringAsFixed(4)} ETH';
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final MarketplaceService _service;

  WalletNotifier(this._service)
      : super(WalletState(
          isSeller: true,
          address: _service.currentAddress,
        )) {
    refreshBalance();
  }

  Future<void> refreshBalance() async {
    state = state.copyWith(isLoading: true);
    try {
      final balance = await _service.getBalance();
      final withdrawable =
          await _service.getWithdrawableBalance(state.address.hexEip55);
      state = state.copyWith(
        balance: balance,
        withdrawable: withdrawable,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void switchAccount() {
    final newIsSeller = !state.isSeller;
    _service.switchAccount(newIsSeller ? sellerPrivateKey : buyerPrivateKey);
    state = WalletState(
      isSeller: newIsSeller,
      address: _service.currentAddress,
    );
    refreshBalance();
  }
}

final marketplaceServiceProvider = Provider<MarketplaceService>((ref) {
  final service = MarketplaceService();
  ref.onDispose(() => service.dispose());
  return service;
});

final walletProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final service = ref.watch(marketplaceServiceProvider);
  return WalletNotifier(service);
});
