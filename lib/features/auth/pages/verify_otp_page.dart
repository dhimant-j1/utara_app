import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:utara_app/core/stores/auth_store.dart';
// import 'package:utara_client/core/theme/app_theme.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;

  const VerifyOtpPage({super.key, required this.phoneNumber});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _resendTimer = 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60; // 60 seconds countdown
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/auth/forgot-password'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon/Illustration
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      // color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      size: 80,
                      // color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Verify OTP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      children: [
                        const TextSpan(text: 'Enter the OTP sent to\n'),
                        TextSpan(
                          text: widget.phoneNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Form
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // OTP Field
                        FormBuilderTextField(
                          name: 'otp',
                          decoration: const InputDecoration(
                            labelText: 'Enter OTP',
                            hintText: 'Enter 6-digit OTP',
                            prefixIcon: Icon(Icons.pin),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'OTP is required',
                            ),
                            FormBuilderValidators.minLength(
                              6,
                              errorText: 'OTP must be 6 digits',
                            ),
                            FormBuilderValidators.maxLength(
                              6,
                              errorText: 'OTP must be 6 digits',
                            ),
                          ]),
                        ),
                        const SizedBox(height: 24),

                        // New Password Field
                        FormBuilderTextField(
                          name: 'new_password',
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'Password is required',
                            ),
                            FormBuilderValidators.minLength(
                              6,
                              errorText:
                                  'Password must be at least 6 characters',
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field
                        FormBuilderTextField(
                          name: 'confirm_password',
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your new password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'Please confirm your password',
                            ),
                            (value) {
                              final password = _formKey
                                  .currentState
                                  ?.fields['new_password']
                                  ?.value;
                              if (value != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ]),
                        ),
                        const SizedBox(height: 32),

                        // Reset Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleResetPassword,
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        // Error Message
                        if (_errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Resend OTP Section
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Didn't receive the OTP?",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              if (_resendTimer > 0)
                                Text(
                                  'Resend OTP in $_resendTimer seconds',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                )
                              else
                                TextButton(
                                  onPressed: _isResending
                                      ? null
                                      : _handleResendOTP,
                                  child: _isResending
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Resend OTP',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password Requirements Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Password Requirements:',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildRequirement('At least 6 characters long'),
                              _buildRequirement(
                                'Contains letters and numbers (recommended)',
                              ),
                              _buildRequirement('Not easily guessable'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Back to Login Link
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/auth/login'),
                            child: const Text(
                              'Back to Sign In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
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

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, top: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue[700], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    final _authStore = GetIt.instance<AuthStore>();
    // Validate form
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final values = _formKey.currentState!.value;
        // ignore: unused_local_variable
        final otp = values['otp'] as String;
        // ignore: unused_local_variable
        final newPassword = values['new_password'] as String;

        // TODO: Implement API call to verify OTP and reset password
        // Example:
        // await _authStore.resetPassword(widget.phoneNumber, otp, newPassword);

        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 2));

        // Show success dialog
        if (mounted) {
          _showSuccessDialog();
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Invalid OTP or failed to reset password. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendOTP() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final _authStore = GetIt.instance<AuthStore>();
      // TODO: Implement API call to resend OTP
      // Example:
      // await _authService.requestPasswordResetOTP(widget.phoneNumber);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('OTP has been resent successfully!'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Restart timer
        _startResendTimer();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend OTP. Please try again.';
      });
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Password Reset Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your password has been reset successfully. You can now sign in with your new password.',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/auth/login');
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
