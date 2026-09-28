import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../state/appointment_provider.dart';
import '../appointments/appointments_page.dart';
import '../articles/articles_page.dart';
import '../doctors/doctor_list_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

/// Mengizinkan halaman anak berpindah tab navigasi bawah.
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.goToTab, required super.child});

  final ValueChanged<int> goToTab;

  static ShellScope of(BuildContext context) {
    final ShellScope? scope = context
        .dependOnInheritedWidgetOfExactType<ShellScope>();
    assert(scope != null, 'ShellScope tidak ditemukan pada konteks ini');
    return scope!;
  }

  @override
  bool updateShouldNotify(ShellScope oldWidget) => false;
}

/// Kerangka utama dengan navigasi bawah lima menu.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late int _index = widget.initialIndex;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    DoctorListPage(),
    AppointmentsPage(),
    ArticlesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Pemuatan janji temu ditangani `appointmentProvider` sendiri,
    // sehingga shell cukup membaca badge-nya.
    final int upcoming = ref.watch(
      appointmentProvider.select((AppointmentState a) => a.upcomingCount),
    );

    return ShellScope(
      goToTab: (int i) => setState(() => _index = i),
      child: Scaffold(
        body: IndexedStack(index: _index, children: _pages),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.outline)),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (int i) => setState(() => _index = i),
            destinations: <Widget>[
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search_rounded),
                selectedIcon: Icon(Icons.manage_search_rounded),
                label: 'Cari Dokter',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: upcoming > 0,
                  label: Text('$upcoming'),
                  child: const Icon(Icons.event_note_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: upcoming > 0,
                  label: Text('$upcoming'),
                  child: const Icon(Icons.event_note_rounded),
                ),
                label: 'Janji Temu',
              ),
              const NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article_rounded),
                label: 'Artikel',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
