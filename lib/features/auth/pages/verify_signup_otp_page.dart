import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
// import 'package:utara_client/core/theme/app_theme.dart';
import '../../../core/stores/auth_store.dart';

class VerifySignupOtpPage extends StatefulWidget {
  final String phoneNumber;

  const VerifySignupOtpPage({super.key, required this.phoneNumber});

  @override
  State<VerifySignupOtpPage> createState() => _VerifySignupOtpPageState();
}

class _VerifySignupOtpPageState extends State<VerifySignupOtpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _authStore = GetIt.instance<AuthStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/Images/BAPS_logo.png'),
                    // backgroundColor: AppTheme.appBarColor,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Enter Verification Code',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: AppTheme.appBarColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'We sent a code to ${widget.phoneNumber}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // OTP Form
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'otp',
                        decoration: const InputDecoration(
                          labelText: 'Enter OTP',
                          prefixIcon: Icon(Icons.password),
                          helperText: 'Enter the 6-digit code',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.minLength(6),
                          FormBuilderValidators.maxLength(6),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: _authStore.isLoading
                                ? null
                                : _handleVerifyOtp,
                            child: _authStore.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Verify & Create Account'),
                          ),
                        ),
                      ),

                      // Error Message
                      Observer(
                        builder: (_) => _authStore.errorMessage != null
                            ? Container(
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
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _authStore.errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 24),

                      // Resend OTP
                      Center(
                        child: TextButton(
                          onPressed: _authStore.isLoading
                              ? null
                              : () {
                                  context.pop();
                                  // User can go back and submit the form again
                                },
                          child: const Text('Didn\'t receive code? Go back'),
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
    );
  }

  Future<void> _handleVerifyOtp() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      final success = await _authStore.verifySignupOtp(
        phoneNumber: widget.phoneNumber,
        otp: values['otp'] as String,
      );

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to dashboard
        context.go('/dashboard');
      }
    }
  }

  @override
  void dispose() {
    _authStore.clearError();
    super.dispose();
  }
}
