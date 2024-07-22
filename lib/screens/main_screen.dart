import 'package:flutter/material.dart';
import 'package:test3/providers/money_provider.dart';
import 'package:test3/providers/patients_provider.dart';

import 'package:test3/screens/drawer_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test3/screens/register_screen.dart';
import 'package:test3/screens/search_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  late Future<void> _combinedFuture;

  @override
  void initState() {
    super.initState();
    _combinedFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      ref.read(patientsProvider.notifier).loadDb(),
      ref.read(moneyProvider.notifier).loadFromDb(),
    ]);
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget mainContent =
        currentIndex == 0 ? const RegisterScreen() : const SearchScreen();
    return Scaffold(
      /* 
        backgroundColor: Color.fromARGB(255, 152, 114, 114), */
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF0E1731),
        centerTitle: true,
        title: const Text(
          'Davr Med Servise',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _combinedFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: Text('Loading'))
                : mainContent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 7.0,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: 'Регистрация'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt), label: 'Список пациентов'),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        iconSize: 35,
      ),
      drawer: const MainDrawer(),
    );
  }
}
