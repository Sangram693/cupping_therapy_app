import 'package:flutter/material.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
  });

  final String submitLabel;
  final Future<void> Function({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  })
  onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  String? _submitError;
  Map<String, List<String>> _validationErrors = {};

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final hasContact =
        _emailController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty;
    setState(() {
      _showTermsError = !_acceptedTerms;
      _submitError = null;
      _validationErrors = {};
    });

    if (!hasContact || !isValid || !_acceptedTerms || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmationController.text,
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _submitError = error is AppException
              ? error.message
              : error.toString();
          _validationErrors = error is AppException
              ? error.validationErrors
              : {};
        });
        _formKey.currentState?.validate();
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            labelText: l10n.fullName,
            hintText: l10n.nameHint,
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            validator: (value) =>
                _serverError('name') ??
                Validators.validateRequired(
                  value,
                  requiredMessage: l10n.fieldRequired(l10n.fullName),
                ),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _emailController,
            labelText: l10n.email,
            hintText: l10n.emailHint,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final serverError = _serverError('email');
              if (serverError != null) return serverError;
              if (value == null || value.trim().isEmpty) return null;
              return Validators.validateEmail(
                value,
                requiredMessage: l10n.emailRequired,
                invalidMessage: l10n.invalidEmail,
              );
            },
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _phoneController,
            labelText: l10n.phoneOptional,
            hintText: l10n.phoneNumberHint,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (_) => _serverError('phone'),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _passwordController,
            labelText: l10n.password,
            hintText: l10n.passwordLengthHint,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconTooltip: l10n.passwordVisibility,
            onSuffixIconPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            validator: (value) =>
                _serverError('password') ??
                Validators.validatePassword(
                  value,
                  requiredMessage: l10n.passwordRequired,
                  minLengthMessage: l10n.passwordMinLength(8),
                ),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _confirmationController,
            labelText: l10n.confirmPassword,
            hintText: l10n.confirmPasswordHint,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmation,
            suffixIcon: _obscureConfirmation
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            suffixIconTooltip: l10n.passwordVisibility,
            onSuffixIconPressed: () {
              setState(() => _obscureConfirmation = !_obscureConfirmation);
            },
            validator: (value) {
              final serverError = _serverError('password_confirmation');
              if (serverError != null) return serverError;
              if (value == null || value.isEmpty) {
                return l10n.confirmPasswordRequired;
              }
              if (value != _passwordController.text) {
                return l10n.passwordsDoNotMatch;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _acceptedTerms,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: colorScheme.primary,
            title: Text(
              l10n.termsAndPrivacy,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
                _showTermsError = false;
              });
            },
          ),
          if (_showTermsError)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                l10n.termsRequired,
                style: TextStyle(color: colorScheme.error, fontSize: 12),
              ),
            ),
          if (_emailController.text.trim().isEmpty &&
              _phoneController.text.trim().isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                l10n.emailOrPhoneRequired,
                style: TextStyle(color: colorScheme.error, fontSize: 12),
              ),
            ),
          if (_submitError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _submitError!,
                style: TextStyle(color: colorScheme.error),
              ),
            ),

          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
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

  String? _serverError(String field) => _validationErrors[field]?.firstOrNull;
}
