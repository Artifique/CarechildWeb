import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:flutter/material.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  Utilisateur? currentUser; // Stocke l'utilisateur courant
  final UtilisateurService utilisateurService = UtilisateurService();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Variables pour gérer la visibilité des mots de passe
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool isLoading = true; // Variable pour gérer le chargement

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Récupère les informations de l'utilisateur courant
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      isLoading = true; // Démarre le chargement
    });
    currentUser = await utilisateurService.getCurrentUtilisateur(); // Récupère l'utilisateur courant
    if (currentUser != null) {
      // Remplit les contrôleurs avec les informations de l'utilisateur
      nomController.text = currentUser!.nom;
      emailController.text = currentUser!.email;
      telController.text = currentUser!.tel;
      adresseController.text = currentUser!.adresse;
    }
    setState(() {
      isLoading = false; // Arrête le chargement
    });
  }

  Future<void> _updateUser() async {
    // Met à jour l'utilisateur avec les nouvelles informations
    Utilisateur updatedUser = currentUser!.copyWith(
      nom: nomController.text,
      email: emailController.text,
      tel: telController.text,
      adresse: adresseController.text,
      // Ajoute d'autres champs si nécessaire
    );

    await utilisateurService.updateUtilisateur(updatedUser); // Appelle la méthode pour mettre à jour l'utilisateur
    // Tu peux ajouter un message de confirmation ou rediriger l'utilisateur si nécessaire
  }

Future<void> _updatePassword() async {
  // Vérifie que les nouveaux mots de passe correspondent
  if (newPasswordController.text == confirmPasswordController.text) {
    // Appelle la méthode pour changer le mot de passe
    bool success = await utilisateurService.updatePassword(
        currentUser!.id, oldPasswordController.text, newPasswordController.text);
    
    if (success) {
      // Efface les contrôleurs de mot de passe
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
      // Affiche un message de confirmation
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe modifié avec succès')),
      );
    } else {
      // Affiche une erreur si le changement de mot de passe échoue
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la modification du mot de passe')),
      );
    }
  } else {
    // Affiche une erreur si les mots de passe ne correspondent pas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Affiche un indicateur de chargement
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Partie Gauche
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 4.5,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          currentUser != null 
                              ? 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F${currentUser!.id}%2Fprofile.jpg?alt=media'
                              : 'https://example.com/default_profil.png', // URL de l'image par défaut
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            // Affiche une image par défaut en cas d'erreur
                            return Image.asset(
                              'images/default_profil.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser?.email ?? 'Chargement...',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Container(
                  width: MediaQuery.of(context).size.width / 4.5,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        const Text(
                          'Informations',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Nom: ${currentUser?.nom ?? 'Chargement...'}'),
                        const SizedBox(height: 10),
                        Text('Email: ${currentUser?.email ?? 'Chargement...'}'),
                        const SizedBox(height: 10),
                        Text('Tel: ${currentUser?.tel ?? 'Chargement...'}'),
                        Text('Adresse: ${currentUser?.adresse ?? 'Chargement...'}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Fin Partie Gauche
            const SizedBox(width: 20),

            // Partie Droite - Formulaire
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Modifier les Informations',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nomController, // Utilise le contrôleur
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: emailController, // Utilise le contrôleur
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: adresseController, // Utilise le contrôleur
                            decoration: const InputDecoration(
                              labelText: 'Adresse',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: telController, // Utilise le contrôleur
                            decoration: const InputDecoration(
                              labelText: 'Téléphone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUser, // Appelle la méthode de mise à jour de l'utilisateur
                      child: const Text('Mettre à jour les informations'),
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 2),
                    const SizedBox(height: 20),
                    const Text(
                      'Changer le Mot de Passe',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: oldPasswordController, // Utilise le contrôleur
                      obscureText: _obscureOldPassword, // Gère la visibilité
                      decoration: InputDecoration(
                        labelText: 'Ancien Mot de Passe',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOldPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureOldPassword = !_obscureOldPassword; // Bascule la visibilité
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: newPasswordController, // Utilise le contrôleur
                      obscureText: _obscureNewPassword, // Gère la visibilité
                      decoration: InputDecoration(
                        labelText: 'Nouveau Mot de Passe',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword; // Bascule la visibilité
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController, // Utilise le contrôleur
                      obscureText: _obscureConfirmPassword, // Gère la visibilité
                      decoration: InputDecoration(
                        labelText: 'Confirmer le Mot de Passe',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword; // Bascule la visibilité
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updatePassword, // Appelle la méthode de mise à jour du mot de passe
                      child: const Text('Changer le Mot de Passe'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
