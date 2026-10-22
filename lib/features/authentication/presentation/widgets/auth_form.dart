import 'package:flutter/material.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            labelText: l10n.fullName,
            hintText: l10n.nameHint,
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            validator: (value) => Validators.validateRequired(
              value,
              requiredMessage: l10n.fieldRequired(l10n.fullName),
            ),
          ),
          const SizedBox(height: 18),
          AppTextField(
            labelText: l10n.email,
            hintText: l10n.emailHint,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validators.validateEmail(
              value,
              requiredMessage: l10n.emailRequired,
              invalidMessage: l10n.invalidEmail,
            ),
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
            validator: (value) => Validators.validatePassword(
              value,
              requiredMessage: l10n.passwordRequired,
              minLengthMessage: l10n.passwordMinLength(8),
            ),
          ),
          const SizedBox(height: 18),
          AppTextField(
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
              padding: EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                l10n.termsRequired,
                style: TextStyle(color: colorScheme.error, fontSize: 12),
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
