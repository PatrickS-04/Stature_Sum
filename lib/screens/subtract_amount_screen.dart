import 'package:flutter/material.dart';
import '../services/storage.dart';

class SubtractAmountScreen extends StatefulWidget {
  const SubtractAmountScreen({super.key});

  @override
  State<SubtractAmountScreen> createState() => _SubtractAmountScreenState();
}

class _SubtractAmountScreenState extends State<SubtractAmountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = Storage();
  final _amountController = TextEditingController();

  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDropdownCategories();
  }

  Future<void> _loadDropdownCategories() async {
    Set<String> assets = await _storage.readAssetList();
    setState(() {
      _categories = assets.toList();
      if (_categories.isNotEmpty) _selectedCategory = _categories.first;
      _isLoading = false;
    });
  }

  void _submitSubtraction() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      String rawAmount = _amountController.text.trim();
      double subtractedWeight = double.parse(rawAmount);

      String assetKey = _selectedCategory!.toLowerCase();
      double currentBalance = await _storage.readFloat(assetKey);
      
      double updatedBalance = currentBalance - subtractedWeight;
      await _storage.writeFloat(assetKey, updatedBalance);

      _amountController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subtracted R ${subtractedWeight.toStringAsFixed(2)} from ${_selectedCategory!.toUpperCase()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set to transparent
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF800020), // Burgundy
              Color(0xFF2C2C2C), // Charcoal Grey
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Subtract From Asset",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 35),
                        if (_categories.isEmpty) ...[
                          const Center(
                            child: Text(
                              "Please create an asset category first.",
                              style: TextStyle(color: Colors.white60, fontSize: 16),
                            ),
                          ),
                        ] else ...[
                          DropdownButtonFormField<String>(
                            dropdownColor: const Color(0xFF2C2C2C),
                            value: _selectedCategory,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: const InputDecoration(
                              labelText: 'Select Category',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            ),
                            items: _categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.isEmpty ? "" : "${value[0].toUpperCase()}${value.substring(1)}"),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Amount (R)',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'An amount is required if you want to subtract from your total';
                              if (value.contains(',')) return "Invalid Amount. Must have a '.', not a ','";
                              if (double.tryParse(value) == null) return 'Please enter a valid number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: const Size.fromHeight(55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _submitSubtraction,
                            child: const Text("Subtract Amount from Category", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}