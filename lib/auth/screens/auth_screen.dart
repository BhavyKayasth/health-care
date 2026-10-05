import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../main_screen.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_tabs.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/divider_widget.dart';
import '../widgets/social_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // EMAIL LOGIN / SIGNUP
  // ============================================================

  Future<void> _handleEmailAuth(
      AuthController controller,
      ) async {
    final error =
    await controller.authenticateWithEmail();

    if (!mounted) return;

    if (error != null) {
      _showMessage(error);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  }

  // ============================================================
  // GOOGLE LOGIN / SIGNUP
  // ============================================================

  Future<void> _handleGoogleAuth(
      AuthController controller,
      ) async {
    final error =
    await controller.signInWithGoogle();

    if (!mounted) return;

    if (error != null) {
      _showMessage(error);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      authControllerProvider,
    );

    final controller = ref.read(
      authControllerProvider.notifier,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMiddle,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics:
            const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  const SizedBox(height: 12),

                  const AuthHeader(),

                  const SizedBox(height: 40),

                  // =================================================
                  // LOGIN / SIGNUP TABS
                  // =================================================

                  const AuthTabs(),

                  const SizedBox(height: 32),

                  // =================================================
                  // FORM
                  // =================================================

                  AnimatedSize(
                    duration:
                    const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.easeInOut,
                    alignment:
                    Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        // ===========================================
                        // FULL NAME - SIGNUP ONLY
                        // ===========================================

                        AnimatedSwitcher(
                          duration:
                          const Duration(
                            milliseconds: 300,
                          ),
                          switchInCurve:
                          Curves.easeOut,
                          switchOutCurve:
                          Curves.easeIn,
                          transitionBuilder:
                              (
                              child,
                              animation,
                              ) {
                            return SizeTransition(
                              sizeFactor:
                              animation,
                              axisAlignment: -1,
                              child:
                              FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: state.isLogin
                              ? const SizedBox(
                            key: ValueKey(
                              'emptyName',
                            ),
                          )
                              : Column(
                            key: const ValueKey(
                              'nameField',
                            ),
                            children: [
                              AuthTextField(
                                controller:
                                controller
                                    .nameController,
                                label:
                                'Full Name',
                                hint:
                                'Enter your full name',
                                prefixIcon:
                                LucideIcons
                                    .user,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),

                        // ===========================================
                        // EMAIL
                        // ===========================================

                        AuthTextField(
                          controller:
                          controller
                              .emailController,
                          label:
                          'Email Address',
                          hint:
                          'Enter your email',
                          prefixIcon:
                          LucideIcons.mail,
                          keyboardType:
                          TextInputType.emailAddress,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // ===========================================
                        // PASSWORD
                        // ===========================================

                        AuthTextField(
                          controller:
                          controller
                              .passwordController,
                          label: 'Password',
                          hint:
                          'Enter your password',
                          prefixIcon:
                          LucideIcons.lock,
                          obscureText:
                          !state
                              .isPasswordVisible,
                          suffixIcon:
                          state
                              .isPasswordVisible
                              ? LucideIcons.eyeOff
                              : LucideIcons.eye,
                          onSuffixPressed:
                          controller
                              .togglePasswordVisibility,
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        // ===========================================
                        // FORGOT PASSWORD
                        // ===========================================

                        AnimatedSwitcher(
                          duration:
                          const Duration(
                            milliseconds: 250,
                          ),
                          child: state.isLogin
                              ? Align(
                            key: const ValueKey(
                              'forgotPassword',
                            ),
                            alignment:
                            Alignment
                                .centerRight,
                            child: TextButton(
                              onPressed: () {
                                _showMessage(
                                  'Password reset will be added next.',
                                );
                              },
                              style:
                              TextButton.styleFrom(
                                padding:
                                EdgeInsets.zero,
                                minimumSize:
                                Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap,
                              ),
                              child:
                              const Text(
                                'Forgot Password?',
                                style:
                                TextStyle(
                                  color:
                                  AppColors
                                      .primary,
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                              : const SizedBox(
                            key: ValueKey(
                              'emptyForgot',
                            ),
                            height: 10,
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ===========================================
                        // LOGIN / CREATE ACCOUNT
                        // ===========================================

                        AuthButton(
                          text: state.isLogin
                              ? 'Login'
                              : 'Create Account',
                          isLoading:
                          state.isLoading,
                          onPressed: () {
                            if (state.isLoading) {
                              return;
                            }

                            _handleEmailAuth(
                              controller,
                            );
                          },
                        ),

                        const SizedBox(
                          height: 34,
                        ),

                        // ===========================================
                        // DIVIDER
                        // ===========================================

                        const AuthDivider(),

                        const SizedBox(
                          height: 30,
                        ),

                        // ===========================================
                        // GOOGLE
                        // ===========================================

                        SocialButton(
                          text:
                          'Continue with Google',
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color:
                            Color(0xFF4285F4),
                          ),
                          onPressed: () {
                            if (state.isLoading) {
                              return;
                            }

                            _handleGoogleAuth(
                              controller,
                            );
                          },
                        ),

                        const SizedBox(
                          height: 34,
                        ),

                        // ===========================================
                        // TERMS & PRIVACY
                        // ===========================================

                        RichText(
                          textAlign:
                          TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              color:
                              Color(0xFF93C5FD),
                              fontSize: 12,
                              height: 1.6,
                            ),
                            children: [
                              TextSpan(
                                text:
                                'By continuing, you agree to our ',
                              ),
                              TextSpan(
                                text:
                                'Terms of Service',
                                style: TextStyle(
                                  color:
                                  AppColors
                                      .primary,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                              ),
                              TextSpan(
                                text:
                                'Privacy Policy',
                                style: TextStyle(
                                  color:
                                  AppColors
                                      .primary,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
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