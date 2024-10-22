
import 'package:accessability/Dashboard/adminPage.dart';
import 'package:accessability/Dashboard/connexion.dart';
import 'package:accessability/Dashboard/consultationsPage.dart';
import 'package:accessability/Dashboard/dashboard_page.dart';
import 'package:accessability/Dashboard/deconnexion_page.dart';
import 'package:accessability/Dashboard/evenementPage.dart';
import 'package:accessability/Dashboard/notification_page.dart';
import 'package:accessability/Dashboard/ressource_dash.dart';
import 'package:accessability/Dashboard/specialiste_page.dart';
import 'package:accessability/Dashboard/user_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const UsersPage(),
    const SpecialistePage(),
     const EvenementPage(),
    ConsultationsPage(),
  
    const NotificationPage(),
    const Adminpage(),
      const DeconnexionPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 7) {
      _logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => ConnexionPage()),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la déconnexion : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Afficher le menu hamburger pour les petits écrans
          return Scaffold(
            appBar: AppBar(
              title: const Text('CareChild'),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/care.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 5),
                        const Text('Menu', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  buildMenuItem(Icons.dashboard, 'Dashboard', 0),
                  buildMenuItem(Icons.people, 'Parents', 1),
                  buildMenuItem(Icons.person, 'Specialistes', 2),
                  buildMenuItem(Icons.calendar_month, 'Evenements', 3),
                  buildMenuItem(Icons.map, 'Consultations', 4),
                  buildMenuItem(Icons.notifications, 'Notifications', 5),
                  buildMenuItem(Icons.person, 'Profil', 6),
                  buildMenuItem(Icons.logout, 'Déconnexion', 7),
                ],
              ),
            ),
            body: _pages[_selectedIndex],
          );
        } else {
          // Afficher une sidebar fixe pour les grands écrans
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 290,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'images/care.png',
                              height: 210,
                              width: 210,
                            ),
                            const SizedBox(height: 3),
                          ],
                        ),
                      ),
                      buildMenuItem(Icons.dashboard, 'Dashboard', 0),
                      buildMenuItem(Icons.people, 'Parents', 1),
                      buildMenuItem(Icons.person, 'Specialistes', 2),
                      buildMenuItem(Icons.calendar_month, 'Evenements', 3),
                      buildMenuItem(Icons.map, 'Consultations', 4),
                      buildMenuItem(Icons.notifications, 'Notifications', 5),
                      buildMenuItem(Icons.person, 'Profil', 6),
                      buildMenuItem(Icons.logout, 'Déconnexion', 7),
                    ],
                  ),
                ),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildMenuItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black,
      ),
      title: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
      ),
      selected: isSelected,
      onTap: () => _onItemTapped(index),
    );
  }
}
