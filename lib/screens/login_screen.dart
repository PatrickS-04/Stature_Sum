import 'package:flutter/material.dart';
import 'package:stature_sum/screens/main_navigation.dart';
import '../services/storage.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = Storage();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _autoPopulateCredentials();
  }

  void _autoPopulateCredentials() async {
    bool? savedRememberMe = await _storage.readBool('rememberMe');
    if (savedRememberMe == true) {
      String? savedUsername = await _storage.readString('username');
      String? savedPassword = await _storage.readString('password');
      setState(() {
        _rememberMe = true;
        if (savedUsername != null) _usernameController.text = savedUsername;
        if (savedPassword != null) _passwordController.text = savedPassword;
      });
    }
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String inputUsername = _usernameController.text.trim();
      String inputPassword = _passwordController.text;

      String? savedUsername = await _storage.readString('username');
      String? savedPassword = await _storage.readString('password');

      if (inputUsername != savedUsername) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: const Text('Username not found. Please register.')),
        );
        return;
      }

      if (inputPassword != savedPassword) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: const Text('Incorrect Password. Please try again.')),
        );
        return;
      }

      await _storage.writeBool('rememberMe', _rememberMe);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
                          "Welcome Back",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 25),
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: Colors.black,
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                            const Text("Remember Me", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF800020), Color(0xFF2C2C2C)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFD700), width: 2),
                          ),
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ForgotPasswordScreen())),
                          child: const Center(
                            child: Text("Forgot Password", style: TextStyle(color: Color(0xFF42A5F5), fontSize: 19)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Center(child: Text("or", style: TextStyle(color: Colors.black, fontSize: 19))),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterScreen())),
                          child: const Center(
                            child: Text("Create an Account", style: TextStyle(color: Color(0xFF42A5F5), fontSize: 19)),
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
      ),
    );
  }
}