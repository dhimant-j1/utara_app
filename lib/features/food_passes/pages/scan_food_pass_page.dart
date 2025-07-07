import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:utara_app/features/food_passes/stores/food_pass_store.dart';

class ScanFoodPassPage extends StatefulWidget {
  const ScanFoodPassPage({super.key});

  @override
  State<ScanFoodPassPage> createState() => _ScanFoodPassPageState();
}

class _ScanFoodPassPageState extends State<ScanFoodPassPage> {
  late FoodPassStore _foodPassStore;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodPassStore = Provider.of<FoodPassStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Food Pass'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue!;
                _foodPassStore.scanFoodPass(code).then((_) {
                  if (_foodPassStore.errorMessage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pass Scanned Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_foodPassStore.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              }
            },
          ),
          // Add a scanner overlay
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }
}
