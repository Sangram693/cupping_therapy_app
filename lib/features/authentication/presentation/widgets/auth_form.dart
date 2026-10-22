import 'package:flutter/material.dart';

import '../../../../core/services/app_color_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
  });

  final String submitLabel;
  final VoidCallback onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _showTermsError = !_acceptedTerms);

    if (isValid && _acceptedTerms) {
      widget.onSubmit();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            labelText: 'Full name',
            hintText: 'Enter your name',
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                Validators.validateRequired(value, fieldName: 'Name'),
          ),
          const SizedBox(height: 18),
          AppTextField(
            labelText: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'At least 8 characters',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 18),
          AppTextField(
            labelText: 'Confirm password',
            hintText: 'Enter your password again',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmation,
            suffixIcon: _obscureConfirmation
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () {
              setState(() => _obscureConfirmation = !_obscureConfirmation);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password.';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _acceptedTerms,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            title: const Text(
              'I agree to the terms and privacy policy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
                _showTermsError = false;
              });
            },
          ),
          if (_showTermsError)
            const Padding(
              padding: EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                'Please accept the terms to continue.',
                style: TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                widget.submitLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
