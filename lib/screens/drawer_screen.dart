import 'package:flutter/material.dart';
import 'package:test3/screens/settings.dart';
import 'package:test3/screens/statistics.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF212252),
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/logo.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 35,
            ),
            title: const Text(
              'Главная',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.show_chart_outlined,
              color: Colors.white,
              size: 35,
            ),
            title: const Text(
              'Статистика',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StatisticsScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 35,
            ),
            title: const Text(
              'Настройки',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
