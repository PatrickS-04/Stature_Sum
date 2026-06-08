import 'package:flutter/material.dart';
import '../services/storage.dart';

class DisplayTotalScreen extends StatefulWidget {
  const DisplayTotalScreen({super.key});

  @override
  State<DisplayTotalScreen> createState() => _DisplayTotalScreenState();
}

class _DisplayTotalScreenState extends State<DisplayTotalScreen> {
  final _storage = Storage();
  double _totalWealth = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTotalWealth();
  }

  Future<void> _loadTotalWealth() async {
    setState(() => _isLoading = true);
    
    Set<String> assetList = await _storage.readAssetList();

    double aggregatedTotal = 0.0;
    for (String asset in assetList) {
      double assetBalance = await _storage.readFloat(asset.toLowerCase());
      aggregatedTotal += assetBalance;
    }

    setState(() {
      _totalWealth = aggregatedTotal;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF800020),
              Color(0xFF2C2C2C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'assets/stature_sum_logo.png',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      "Stature Sum",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Stature Sum/Total Wealth:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD4AF37)),
                            )
                          : Text(
                              "R ${_totalWealth.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // Closes Container
    ); // Closes Scaffold
  } // Closes Widget build
} // Closes _DisplayTotalScreenState