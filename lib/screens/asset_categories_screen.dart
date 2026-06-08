import 'package:flutter/material.dart';
import '../services/storage.dart';

class AssetCategoryScreen extends StatefulWidget {
  const AssetCategoryScreen({super.key});

  @override
  State<AssetCategoryScreen> createState() => _AssetCategoryScreenState();
}

class _AssetCategoryScreenState extends State<AssetCategoryScreen> {
  final _storage = Storage();
  final _addFormKey = GlobalKey<FormState>();
  final _assetInputController = TextEditingController();

  Set<String> _savedAssets = {};
  Map<String, double> _assetBalances = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssetCategories();
  }

  Future<void> _loadAssetCategories() async {
    setState(() => _isLoading = true);
    Set<String> assets = await _storage.readAssetList();
    Map<String, double> balances = {};
    
    for (String asset in assets) {
      double balance = await _storage.readFloat(asset.toLowerCase());
      balances[asset] = balance;
    }

    setState(() {
      _savedAssets = assets;
      _assetBalances = balances;
      _isLoading = false;
    });
  }

  void _showAddAssetBottomSheet() {
    _assetInputController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25, right: 25, top: 25,
        ),
        child: Form(
          key: _addFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Add Asset Category", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextFormField(
                controller: _assetInputController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Asset Name (e.g. Crypto, Cash)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a valid Asset Category';
                  if (_savedAssets.contains(value.trim().toLowerCase())) return 'Asset already exists';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 15)),
                onPressed: () async {
                  if (_addFormKey.currentState!.validate()) {
                    String cleanName = _assetInputController.text.trim().toLowerCase();
                    _savedAssets.add(cleanName);
                    await _storage.writeAssetList(_savedAssets);
                    await _storage.writeFloat(cleanName, 0.0);
                    Navigator.pop(context);
                    _loadAssetCategories();
                  }
                },
                child: const Text("ADD ASSET"),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAsset(String assetName) async {
    _savedAssets.remove(assetName.toLowerCase());
    await _storage.writeAssetList(_savedAssets);
    _loadAssetCategories();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${assetName.toUpperCase()} removed successfully.')),
    );
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
              const SizedBox(height: 25),
              const Text("Asset Categories", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _savedAssets.isEmpty
                        ? const Center(child: Text("No asset categories found.", style: TextStyle(color: Colors.white60, fontSize: 16)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            itemCount: _savedAssets.length,
                            itemBuilder: (context, index) {
                              String asset = _savedAssets.elementAt(index);
                              double balance = _assetBalances[asset] ?? 0.0;
                              String formattedName = asset.isEmpty ? "" : "${asset[0].toUpperCase()}${asset.substring(1)}";

                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2C2C),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("$formattedName:", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Text("R ${balance.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                          onPressed: () => _deleteAsset(asset),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("ADD ASSET CATEGORY", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showAddAssetBottomSheet,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}