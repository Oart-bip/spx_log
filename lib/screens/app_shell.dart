import 'package:flutter/material.dart';

import '../widgets/control_nav.dart';
import 'home_screen.dart';
import 'launches_screen.dart';
import 'rockets_screen.dart';

// Estrutura principal: telas empilhadas (mantêm o estado) + navegação própria.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _current = 0;

  static const _items = [
    NavItem('01', 'INÍCIO'),
    NavItem('02', 'MISSÕES'),
    NavItem('03', 'FROTA'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _current,
        children: const [
          HomeScreen(),
          LaunchesScreen(),
          RocketsScreen(),
        ],
      ),
      bottomNavigationBar: ControlNav(
        items: _items,
        current: _current,
        onChanged: (i) => setState(() => _current = i),
      ),
    );
  }
}
