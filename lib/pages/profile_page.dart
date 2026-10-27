import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/app_routes.dart';
import '../models/models.dart';
import '../data/dummy_data.dart';

enum ProfileStatus {
  student('Mahasiswa'),
  freelancer('Freelancer'),
  intern('Magang'),
  employee('Karyawan');

  const ProfileStatus(this.label);
  final String label;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFollowing = false;
  int _followers = 1200;
  bool _openToWork = false;
  bool _isBioExpanded = false;

  ProfileStatus _status = ProfileStatus.student;

  static const _allSkills = ['Flutter', 'Dart', 'UI/UX', 'Firebase', 'Git'];

  final Set<String> _skills = {'Flutter'};

  // Data profil yang bisa diperbarui.
  late Profile _profile;

  @override
  void initState() {
    super.initState();
    _profile = defaultProfile;
  }

  // Lab 3: membuka halaman edit dan menerima data hasil edit.
  Future<void> _openEditProfile() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editProfile,
      arguments: _profile,
    );

    // Jika halaman sudah tidak aktif atau edit dibatalkan,
    // jangan mengubah data profil.
    if (!mounted || result is! Profile) return;

    setState(() => _profile = result);
  }

  // Membuka halaman detail proyek.
  void _openProjectDetail(Project project) {
    Navigator.pushNamed(context, AppRoutes.projectDetail, arguments: project);
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false,
    );
  }

  void _setFollowing(bool value) {
    if (_isFollowing == value) return;

    setState(() {
      _isFollowing = value;
      _followers += value ? 1 : -1;
    });
  }

  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _onFollowPressed() async {
    if (!_isFollowing) {
      _setFollowing(true);

      _showSnack(
        'Kamu mulai mengikuti ${_profile.name}',
        action: SnackBarAction(
          label: 'BATAL',
          onPressed: () => _setFollowing(false),
        ),
      );

      return;
    }

    final confirmed = await _showConfirmDialog(
      title: 'Berhenti mengikuti?',
      message: 'Kamu tidak akan lagi melihat pembaruan dari ${_profile.name}.',
      confirmLabel: 'Berhenti',
    );

    if (!confirmed || !mounted) return;

    _setFollowing(false);
    _showSnack('Kamu berhenti mengikuti ${_profile.name}');
  }

  void _onSkillChanged(String skill, bool selected) {
    setState(() {
      if (selected) {
        _skills.add(skill);
      } else {
        _skills.remove(skill);
      }
    });
  }

  Future<void> _onResetPressed() async {
    final confirmed = await _showConfirmDialog(
      title: 'Reset pengaturan?',
      message: 'Semua pengaturan akan kembali ke nilai awal.',
      confirmLabel: 'Reset',
    );

    if (!confirmed || !mounted) return;

    setState(() {
      _openToWork = false;
      _skills
        ..clear()
        ..add('Flutter');
      _status = ProfileStatus.student;
    });

    _showSnack('Pengaturan berhasil direset');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil Digital'),
        actions: [
          IconButton(
            onPressed: _openEditProfile,
            tooltip: 'Edit Profil',
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _logout,
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          'assets/images/profile_placeholder.svg',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              _profile.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            Text(_status.label, textAlign: TextAlign.center),

            if (_openToWork) ...[
              const SizedBox(height: 8),
              const Center(
                child: Chip(
                  avatar: Icon(Icons.work_outline, size: 18),
                  label: Text('Open to Work'),
                ),
              ),
            ],

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const _StatItem(label: 'Postingan', value: '48'),
                    _StatItem(label: 'Pengikut', value: '$_followers'),
                    const _StatItem(label: 'Mengikuti', value: '320'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            _isFollowing
                ? OutlinedButton.icon(
                    onPressed: _onFollowPressed,
                    icon: const Icon(Icons.check),
                    label: const Text('Mengikuti'),
                  )
                : FilledButton.icon(
                    onPressed: _onFollowPressed,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Ikuti'),
                  ),

            const SizedBox(height: 16),

            // Tentang profil.
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _isBioExpanded = !_isBioExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tentang', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _profile.bio,
                        maxLines: _isBioExpanded ? null : 2,
                        overflow: _isBioExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isBioExpanded ? 'Tutup' : 'Selengkapnya',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Daftar proyek.
            Text('Proyek Saya', style: textTheme.titleLarge),
            const SizedBox(height: 8),

            ...dummyProjects.map(
              (project) => Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.folder_outlined),
                  ),
                  title: Text(project.title),
                  subtitle: Text(project.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openProjectDetail(project),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Keahlian.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Keahlian', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (_skills.isEmpty)
                      const Text('Belum ada keahlian dipilih')
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final skill in _skills) Chip(label: Text(skill)),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            _SettingsCard(
              openToWork: _openToWork,
              onOpenToWorkChanged: (value) {
                setState(() => _openToWork = value);
              },
              allSkills: _allSkills,
              selectedSkills: _skills,
              onSkillChanged: _onSkillChanged,
              status: _status,
              onStatusChanged: (value) {
                setState(() => _status = value);
              },
              onReset: _onResetPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: textTheme.titleLarge),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.openToWork,
    required this.onOpenToWorkChanged,
    required this.allSkills,
    required this.selectedSkills,
    required this.onSkillChanged,
    required this.status,
    required this.onStatusChanged,
    required this.onReset,
  });

  final bool openToWork;
  final ValueChanged<bool> onOpenToWorkChanged;
  final List<String> allSkills;
  final Set<String> selectedSkills;
  final void Function(String skill, bool selected) onSkillChanged;
  final ProfileStatus status;
  final ValueChanged<ProfileStatus> onStatusChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan Profil', style: textTheme.titleMedium),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Open to Work'),
              subtitle: const Text('Tampilkan lencana di kartu profilmu'),
              value: openToWork,
              onChanged: onOpenToWorkChanged,
            ),

            const Divider(),
            const Text('Keahlian'),

            for (final skill in allSkills)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(skill),
                value: selectedSkills.contains(skill),
                onChanged: (value) {
                  onSkillChanged(skill, value ?? false);
                },
              ),

            const Divider(),
            const Text('Status'),

            DropdownButton<ProfileStatus>(
              isExpanded: true,
              value: status,
              items: [
                for (final item in ProfileStatus.values)
                  DropdownMenuItem(value: item, child: Text(item.label)),
              ],
              onChanged: (value) {
                if (value != null) {
                  onStatusChanged(value);
                }
              },
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset pengaturan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
