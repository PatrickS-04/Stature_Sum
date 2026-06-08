import 'package:flutter/material.dart';
import '../services/storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = Storage();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String username = _usernameController.text.trim();
      String password = _passwordController.text;

      final specialCharRegex = RegExp(r'[^a-zA-Z0-9]');
      final capitalLetterRegex = RegExp(r'[A-Z]');
      final numberRegex = RegExp(r'[0-9]');

      if (password.length < 8 ||
          !specialCharRegex.hasMatch(password) ||
          !capitalLetterRegex.hasMatch(password) ||
          !numberRegex.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password must be at least 8 characters, contain a capital letter, a number, and a special character.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      await _storage.writeString('name', name);
      await _storage.writeString('email', email);
      await _storage.writeString('username', username);
      await _storage.writeString('password', password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text('Registration Successful! Please Sign In.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // CHANGED TO TRUE
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF800020), Color(0xFF2C2C2C)],
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
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
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 35.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 25),

                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Full Name is required' : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Email Address is required' : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Username is required' : null,
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black54),
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Password is required' : null,
                        ),
                        const SizedBox(height: 30),

                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF800020), Color(0xFF2C2C2C)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFD700), width: 2),
                          ),
                          child: ElevatedButton(
                            onPressed: _handleRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("CREATE ACCOUNT", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Center(
                          child: Text("Already have an Account?", style: TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Center(
                            child: Text("Sign In Here", style: TextStyle(color: Color(0xFF42A5F5), fontSize: 19, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}