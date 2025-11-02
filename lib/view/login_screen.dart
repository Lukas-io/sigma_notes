import 'dart:developer';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:sigma_notes/services/providers/auth_provider.dart';
import 'package:sigma_notes/view/widgets/sigma_button.dart';
import 'package:sigma_notes/view/widgets/sigma_textfield.dart';

import '../core/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return '';
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return '';
  }

  Future<void> _handleLogin() async {
    final emailError = _validateEmail(_emailController.text.trim());
    final passwordError = _validatePassword(_passwordController.text);

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      setState(() {
        _errorMessage = emailError.isNotEmpty ? emailError : passwordError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final authNotifier = ref.read(authProvider.notifier);
      final success = await authNotifier.login(email, password);

      if (!mounted) return;

      if (success) {
        // Navigate to home on successful login
        context.go(SigmaRoutes.home);
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Login error: $e');
      if (!mounted) return;

      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.loginAsGuest();

      if (!mounted) return;

      // Navigate to home on successful guest login
      context.go(SigmaRoutes.home);
    } catch (e) {
      log('Guest login error: $e');
      if (!mounted) return;

      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state to navigate if already logged in
    ref.listen<AsyncValue>(authProvider, (previous, next) {
      if (next.hasValue && next.value != null && mounted) {
        context.go(SigmaRoutes.home);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 72, right: 16, left: 16),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "sigma",
                  style: TextStyle(
                    color: SigmaColors.darkGreen,
                    fontSize: 52,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "A digital vault for wandering ideas🤸‍♂️",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 36),
                SigmaTextField(
                  label: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SigmaTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                  onSubmitted: (_) => _handleLogin(),
                ),
                AnimatedSize(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: _errorMessage == null
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                ),
                SizedBox(height: 24),
                SigmaButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Start your Journey",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: _isLoading ? null : _handleGuestLogin,
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 12,
                    cornerSmoothing: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(
                          "Continue as a",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isLoading ? SigmaColors.gray : null,
                          ),
                        ),
                        SvgPicture.asset(SigmaAssets.ghostSvg),
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
