import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Sign up page for user registration
class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Use ValueNotifiers for better performance - only rebuild specific widgets
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _obscurePasswordNotifier = ValueNotifier<bool>(true);
  final _obscureConfirmPasswordNotifier = ValueNotifier<bool>(true);
  final _acceptTermsNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isLoadingNotifier.dispose();
    _obscurePasswordNotifier.dispose();
    _obscureConfirmPasswordNotifier.dispose();
    _acceptTermsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Back to Navigator',
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/sign-in'),
            child: const Text('Sign In'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome message
                    Text(
                      'Join Cashense',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your journey to better financial management',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field with optimized state management
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePasswordNotifier,
                      builder: (context, obscurePassword, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Create a strong password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                _obscurePasswordNotifier.value =
                                    !obscurePassword;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                            ).hasMatch(value)) {
                              return 'Password must contain uppercase, lowercase, and number';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field with optimized state management
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirmPasswordNotifier,
                      builder: (context, obscureConfirmPassword, child) {
                        return TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                _obscureConfirmPasswordNotifier.value =
                                    !obscureConfirmPassword;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _handleSignUp(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Terms and conditions checkbox with optimized state management
                    ValueListenableBuilder<bool>(
                      valueListenable: _acceptTermsNotifier,
                      builder: (context, acceptTerms, child) {
                        return CheckboxListTile(
                          value: acceptTerms,
                          onChanged: (value) {
                            _acceptTermsNotifier.value = value ?? false;
                          },
                          title: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            style: theme.textTheme.bodyMedium,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Sign up button with optimized state management
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLoadingNotifier,
                      builder: (context, isLoading, child) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _acceptTermsNotifier,
                          builder: (context, acceptTerms, child) {
                            return FilledButton(
                              onPressed: (isLoading || !acceptTerms)
                                  ? null
                                  : _handleSignUp,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Create Account'),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sign in link
                    TextButton(
                      onPressed: () => context.go('/sign-in'),
                      child: const Text('Already have an account? Sign In'),
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

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTermsNotifier.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Terms of Service and Privacy Policy',
          ),
        ),
      );
      return;
    }

    _isLoadingNotifier.value = true;

    try {
      // TODO: Implement actual registration logic
      await Future<void>.delayed(
        const Duration(seconds: 2),
      ); // Simulate API call

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account created successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        _isLoadingNotifier.value = false;
      }
    }
  }
}
