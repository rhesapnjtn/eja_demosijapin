import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/common.dart';
import '../../state/auth_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _old = TextEditingController();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final String? error = await ref
        .read(authProvider.notifier)
        .changePassword(
          oldPassword: _old.text,
          newPassword: _new.text,
          confirmPassword: _confirm.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      AppSnack.show(context, error, error: true);
      return;
    }
    Navigator.of(context).pop();
    AppSnack.show(context, 'Kata sandi berhasil diganti', success: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Kata Sandi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.sm,
            AppSpacing.screenH,
            AppSpacing.xxxl,
          ),
          children: <Widget>[
            AppCard(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _old,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Kata sandi lama',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                    validator: (String? v) => (v == null || v.isEmpty)
                        ? 'Wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _new,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Kata sandi baru',
                      helperText: 'Minimal 6 karakter',
                      prefixIcon: Icon(Icons.lock_reset_rounded),
                    ),
                    validator: (String? v) => (v == null || v.length < 6)
                        ? 'Minimal 6 karakter'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Ulangi kata sandi baru',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                    validator: (String? v) =>
                        v != _new.text ? 'Tidak sama' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Simpan Kata Sandi'),
            ),
          ],
        ),
      ),
    );
  }
}
