import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';

// Assuming AuthService is correctly defined elsewhere.
// class AuthService {
//   Future<String> resetPassword(String token, String newPassword) async {
//     // Simulate API call delay
//     await Future.delayed(const Duration(seconds: 2));
//     if (token.isNotEmpty && newPassword.length >= 6) {
//       return "Success: Your password has been reset successfully! You can now log in.";
//     }
//     return "Error: Invalid or expired token. Please try the forgotten password process again.";
//   }
// }

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

// FIX: Changed SingleTickerProviderStateMixin to TickerProviderStateMixin
// because we have two AnimationControllers.
class _ResetPasswordScreenState extends State<ResetPasswordScreen> with TickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _message;

  // --- Animation Controllers ---
  // Button Animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  // Background Animation
  late AnimationController _bgAnimationController;

  @override
  void initState() {
    super.initState();

    // Button Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Background Animation Controller (for colorful shifting effect)
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bgAnimationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      setState(() => _message = "Passwords do not match.");
      return;
    }

    if (newPassword.length < 6) {
      setState(() => _message = "Password must be at least 6 characters.");
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    // Animate the button/indicator on load start
    _animationController.repeat(reverse: true);

    final response = await _authService.resetPassword(widget.token, newPassword);

    _animationController.stop();

    setState(() {
      _isLoading = false;
      _message = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = _message?.toLowerCase().contains("success") == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set New Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.purpleAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // Fabulous Animated Background
      body: AnimatedBuilder(
        animation: _bgAnimationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.shade50, // Changed to a slightly different light color for variety
                  Colors.deepPurple.shade100,
                  Colors.white,
                ],
                stops: const [0.0, 0.5, 1.0],
                // Animate the begin and end points of the gradient
                begin: Alignment(
                  _bgAnimationController.value * 2 - 1,
                  _bgAnimationController.value * 2 - 1,
                ),
                end: Alignment(
                  1 - _bgAnimationController.value * 2,
                  1 - _bgAnimationController.value * 2,
                ),
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              shadowColor: Colors.deepPurple.shade200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Define New Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your password must be at least 6 characters long.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // New Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(color: Colors.deepPurple),
                      decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle: TextStyle(color: Colors.deepPurple.shade300),
                        prefixIcon: const Icon(Icons.lock_rounded, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password Field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(color: Colors.deepPurple),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.deepPurple.shade300),
                        prefixIcon: const Icon(Icons.lock_open_rounded, color: Colors.deepPurple),
                        filled: true,
                        fillColor: Colors.deepPurple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Animated Reset Button
                    ScaleTransition(
                      scale: _isLoading ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade300.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [Colors.purpleAccent.shade400, Colors.deepPurple],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Message box with fade animation
                    if (_message != null)
                      AnimatedOpacity(
                        opacity: _message != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSuccess ? Colors.green.shade400 : Colors.red.shade400,
                            ),
                          ),
                          child: Text(
                            _message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
