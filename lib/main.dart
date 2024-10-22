
import 'package:accessability/Dashboard/connexion.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Import du service utilisateur
import 'package:accessability/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final UtilisateurService utilisateurService = UtilisateurService();
  
  // Créer l'admin par défaut si nécessaire
  await utilisateurService.createDefaultAdmin();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      // home:  const NewHome(),
      // home:  const Presentation(),
      // home:   const EnfantMobile(),
      home:   ConnexionPage(),

      // home:  const AccueilSpecialiste(),
      routes: {
  
        '/login': (context) => ConnexionPage(),
        // '/routes': (context) => const SpecialistePage(),
      },
    );
  }
}
