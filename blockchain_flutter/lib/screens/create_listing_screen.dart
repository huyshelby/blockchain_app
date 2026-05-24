import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';
import '../providers/marketplace_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/tx_status_indicator.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _uriController = TextEditingController(text: 'ipfs://demo-product');
  final _priceController = TextEditingController(text: '0.001');
  TxStatus _txStatus = TxStatus.idle;
  String? _txHash;
  String? _errorMessage;

  Future<void> _createProduct() async {
    setState(() { _txStatus = TxStatus.pending; _txHash = null; _errorMessage = null; });
    try {
      final service = ref.read(marketplaceServiceProvider);
      final priceWei = BigInt.from(double.parse(_priceController.text) * 1e18);
      final tx = await service.createProduct(_uriController.text, priceWei);
      setState(() { _txStatus = TxStatus.success; _txHash = tx; });
      ref.invalidate(productsProvider);
    } catch (e) {
      setState(() { _txStatus = TxStatus.error; _errorMessage = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Listing', style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: AppSpacing.sm),
            Text('List a new product on the blockchain marketplace',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Color(0x0D281714), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Metadata URI', style: AppTypography.labelLg.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _uriController,
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'ipfs://... or https://...',
                      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      filled: true, fillColor: AppColors.surfaceContainerHighest,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.link, color: AppColors.onSurfaceVariant, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Price (ETH)', style: AppTypography.labelLg.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: '0.001',
                      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      filled: true, fillColor: AppColors.surfaceContainerHighest,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.paid, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: 'Create Product',
                    isLoading: _txStatus == TxStatus.pending,
                    onPressed: _createProduct,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_txStatus != TxStatus.idle)
              TxStatusIndicator(
                status: _txStatus, txHash: _txHash,
                errorMessage: _errorMessage, onRetry: _createProduct,
              ),
          ],
        ),
      ),
    );
  }
}
