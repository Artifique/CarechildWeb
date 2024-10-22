import 'package:accessability/Dashboard/dash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Widgets/bouton.dart'; // Assurez-vous que ce fichier contient le bouton personnalisé

class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Vérification de la validité de l'email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email invalide. Veuillez entrer un email valide.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SidebarPage(), // Changez selon la navigation de votre app
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Aucun utilisateur trouvé pour cet email.';
          break;
        case 'wrong-password':
          errorMessage = 'Mot de passe incorrect.';
          break;
        case 'invalid-email':
          errorMessage = 'Email invalide.';
          break;
        default:
          errorMessage = 'Erreur lors de la connexion. Veuillez réessayer.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Pour d'autres types d'erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la connexion.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Partie gauche avec le formulaire de connexion
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'images/care.png', // Assurez-vous d'ajouter votre logo dans les assets
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Connectez-vous',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Mot de passe oublié ?'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Se Connecter',
                    backgroundColor: const Color.fromARGB(255, 3, 107, 177),
                    textColor: Colors.white,
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      _signIn();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Partie droite avec l'illustration
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'images/connexion.png', // Assurez-vous d'ajouter l'image ici
                  height: 500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}