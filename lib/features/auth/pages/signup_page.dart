import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:utara_app/core/theme/app_theme.dart';
// import 'package:utara_client/core/theme/app_theme.dart';
import '../../../core/stores/auth_store.dart';
import '../../../core/models/user.dart';

import 'dart:developer' as developer;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _authStore = GetIt.instance<AuthStore>();
  String role = 'USER';
  String _countryCode = '+91';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/auth/login'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage('assets/Images/BAPS_logo.png'),
                  // backgroundColor: AppTheme.appBarColor,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join Utara App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: AppTheme.appBarColor,
                  ),
                ),
                Text(
                  'Create your account to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // Signup Form
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(2),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'gaam',
                        decoration: const InputDecoration(
                          labelText: 'Gaam',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'phone_number',
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: CountryCodePicker(
                            onChanged: (value) {
                              // print(value);
                              _countryCode = value.dialCode ?? '+91';
                            },
                            initialSelection: 'IN',
                            favorite: ['+91', 'IN'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            showFlag: false,
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(10),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          helperText: 'Minimum 6 characters',
                        ),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'confirm_password',
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          (value) {
                            final password = _formKey
                                .currentState
                                ?.fields['password']
                                ?.value;
                            if (value != password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ]),
                      ),
                      const SizedBox(height: 16),

                      FutureBuilder<bool>(
                        future: Future.value(
                          Theme.of(context).platform ==
                                  TargetPlatform.android ||
                              Theme.of(context).platform == TargetPlatform.iOS,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            // Mobile device - role is fixed to STAFF
                            role = 'USER';
                            return const SizedBox.shrink();
                          } else {
                            // Desktop/Web - show role dropdown
                            return FormBuilderDropdown<UserRole>(
                              name: 'role',
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                prefixIcon: Icon(Icons.admin_panel_settings),
                              ),
                              items: UserRole.values
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(_getRoleDisplayName(role)),
                                    ),
                                  )
                                  .toList(),
                              validator: FormBuilderValidators.required(),
                              onChanged: (value) {
                                developer.log(value.toString());
                                setState(() {
                                  if (value == UserRole.superAdmin) {
                                    role = 'SUPER_ADMIN';
                                  } else if (value == UserRole.staff) {
                                    role = 'STAFF';
                                  } else {
                                    role = 'USER';
                                  }
                                });
                              },
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: _authStore.isLoading
                                ? null
                                : _handleSignup,
                            child: _authStore.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Create Account'),
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

                      // Sign In Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => context.go('/auth/login'),
                            child: const Text('Sign In'),
                          ),
                        ],
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

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final phoneNumber =
          _countryCode.split('+')[1] + (values['phone_number'] as String);

      final success = await _authStore.signup(
        email: values['email'] as String,
        gaam: values['gaam'] as String,
        password: values['password'] as String,
        name: values['name'] as String,
        phoneNumber: phoneNumber,
        role: role,
      );

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your phone number!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to OTP verification page
        context.push('/auth/verify-signup-otp', extra: phoneNumber);
      }
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.user:
        return 'User';
    }
  }

  @override
  void dispose() {
    _authStore.clearError();
    super.dispose();
  }
}
