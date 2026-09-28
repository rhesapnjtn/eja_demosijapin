import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_date_picker.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/states.dart';
import '../../data/models/app_user.dart';
import '../../state/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _address = TextEditingController();

  String? _gender;
  String _blood = 'O';
  DateTime? _birthDate;
  bool _saving = false;
  bool _seeded = false;

  static const List<String> _bloodTypes = <String>['A', 'B', 'AB', 'O'];

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _nik.dispose();
    _address.dispose();
    super.dispose();
  }

  void _seedFrom(AppUser user) {
    if (_seeded) return;
    _seeded = true;
    _name.text = user.fullName;
    _phone.text = user.phone ?? '';
    _nik.text = user.nik ?? '';
    _address.text = user.address ?? '';
    _gender = user.gender;
    _blood = (user.bloodType ?? '').isEmpty ? 'O' : user.bloodType!;
    _birthDate = user.birthDate;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await AppDatePicker.pickBirthDate(
      context,
      initialDate: _birthDate,
    );
    if (picked != null && mounted) setState(() => _birthDate = picked);
  }

  Future<void> _save(AppUser user) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final bool ok = await ref
        .read(authProvider.notifier)
        .updateProfile(
          user.copyWith(
            fullName: _name.text.trim(),
            phone: Fmt.digitsOnly(_phone.text),
            nik: Fmt.digitsOnly(_nik.text),
            birthDate: _birthDate,
            gender: _gender,
            bloodType: _blood,
            address: _address.text.trim(),
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop();
      AppSnack.show(context, 'Profil berhasil diperbarui', success: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    final AppUser? user = ref.watch(authProvider).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profil')),
        body: const LoadingView(lines: 2, showAvatar: false),
      );
    }
    _seedFrom(user);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
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
            Center(
              child: Column(
                children: <Widget>[
                  UserAvatar(name: user.fullName, size: 84),
                  const SizedBox(height: AppSpacing.md),
                  Text(user.fullName, style: t.titleMedium),
                  Text(user.email, style: t.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama lengkap',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: V.name,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(V.maxPhoneLength),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: V.phone,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _nik,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(V.nikLength),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'NIK',
                      helperText: '16 digit, ditampilkan tersensor',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: V.nik,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: AppRadius.fieldRadius,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal lahir',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _birthDate == null
                                  ? 'Belum diisi'
                                  : Fmt.dateSlash(_birthDate),
                              style: _birthDate == null
                                  ? t.bodyMedium
                                  : t.titleSmall,
                            ),
                          ),
                          Text(
                            Fmt.ageFrom(_birthDate) == null
                                ? Fmt.empty
                                : '${Fmt.ageFrom(_birthDate)} tahun',
                            style: t.bodySmall?.copyWith(
                              color: AppColors.goldenCaramel,
                              fontWeight: w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _GenderButton(
                          label: 'Laki-laki',
                          selected: _gender == 'L',
                          icon: Icons.male_rounded,
                          onTap: () => setState(() => _gender = 'L'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _GenderButton(
                          label: 'Perempuan',
                          selected: _gender == 'P',
                          icon: Icons.female_rounded,
                          onTap: () => setState(() => _gender = 'P'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Golongan darah', style: t.bodySmall),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: _bloodTypes
                        .map(
                          (String b) => SoftChip(
                            label: b,
                            selected: _blood == b,
                            color: AppColors.danger,
                            onTap: () => setState(() => _blood = b),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _address,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 56),
                        child: Icon(Icons.location_on_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _saving ? null : () => _save(user),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryContainer : AppColors.surface,
      borderRadius: AppRadius.fieldRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.fieldRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadius.fieldRadius,
            border: Border.all(
              color: selected ? AppColors.goldenCaramel : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: selected
                    ? AppColors.goldenCaramel
                    : AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: selected ? w700 : w500,
                  color: selected
                      ? AppColors.goldenCaramel
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
