// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api


import 'package:accessability/Modele/enfant_modele%20.dart';
import 'package:accessability/Services/assignation_service.dart';
import 'package:accessability/Services/enfant_service.dart';
import 'package:accessability/Services/recherche_sevice.dart';
import 'package:accessability/Services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:flutter/foundation.dart';

class SpecialistePage extends StatefulWidget {
  const SpecialistePage({super.key});

  @override
  _SpecialistePageState createState() => _SpecialistePageState();
}

class _SpecialistePageState extends State<SpecialistePage> {
  final UsersService utilisateurService = UsersService();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final RechercheService rechercheService = RechercheService(); // Instance du service de recherche
  final EnfantService enfantService = EnfantService();
  final AssignationService assignationService = AssignationService();

  String specialite = "Psychologue"; // Défaut, modifiable via Dropdown
  File? imageFile;
  Uint8List? webImageFile; // Image pour la version web
  List<Utilisateur> specialistes = []; // Liste des spécialistes
  List<Enfant> enfants = [];
  Utilisateur? utilisateur; // Utilisateur à modifier ou ajouter
   Enfant? selectedEnfant;
  Utilisateur? selectedSpecialiste;



  
  @override
  void initState() {
    super.initState();
    fetchSpecialistes(); // Récupérer la liste des spécialistes au démarrage
         fetchEnfantsEtSpecialistes(); 
  }

bool isLoading = false; // Ajoutez cette variable pour l'état de chargement

Future<void> rechercherSpecialistes(String query) async {
  setState(() {
    isLoading = true; // Commence le chargement
  });
  if (kDebugMode) {
    print("Recherche pour: $query");
  }
  if (query.isNotEmpty) {
    List<Utilisateur> results = await rechercheService.rechercherUtilisateurs(query);
    if (kDebugMode) {
      print("Résultats trouvés: ${results.length}");
    } // Ajoutez ce log
    setState(() {
      specialistes = results; // Met à jour la liste des spécialistes
      isLoading = false; // Fin du chargement
    });
  } else {
    await fetchSpecialistes(); // Récupère tous les spécialistes si la requête est vide

  }
}

  Future<void> fetchEnfantsEtSpecialistes() async {
    enfants = await enfantService.getAllEnfants(); // Récupérer tous les enfants
    specialistes;
    setState(() {});
  }
 

  Future<void> fetchSpecialistes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .where('role',  whereIn: ['Ergothérapeute', 'Orthophoniste', 'Psychologue'])
          .get();

      List<Utilisateur> fetchedSpecialistes = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Utilisateur(
          id: doc.id,
          nom: data['nom'],
          email: data['email'],
          tel: data['tel'],
          adresse: data['adresse'],
          image: data['image'],
          role: data['role'],
          mdp: '', // Ne pas récupérer le mot de passe ici
        );
      }).toList();

      setState(() {
        specialistes = fetchedSpecialistes;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des spécialistes: $e");
      }
    }
  }

  Future<void> selectImage() async {
    if (kIsWeb) {
      // Version web: Utilisation de ImagePickerWeb pour sélectionner une image
      Uint8List? selectedImage = await utilisateurService.webSelectImage();
      if (selectedImage != null) {
        setState(() {
          webImageFile = selectedImage;
        });
      }
    } else {
      // Version mobile: Utilisation de ImagePicker pour sélectionner une image
      // ignore: no_leading_underscores_for_local_identifiers
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }
  }


// Boite de dialogue pour assigner un enfant à un spécialiste
  void showAssignationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Assigner un spécialiste à un enfant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                DropdownButton<Enfant>(
                  hint: const Text('Sélectionnez un enfant'),
                  value: selectedEnfant,
                  onChanged: (Enfant? newValue) {
                    setState(() {
                      selectedEnfant = newValue!;
                    });
                  },
                  items: enfants.map((Enfant enfant) {
                    return DropdownMenuItem<Enfant>(
                      value: enfant,
                      child: Text(enfant.nom),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                DropdownButton<Utilisateur>(
                  hint: const Text('Sélectionnez un spécialiste'),
                  value: selectedSpecialiste,
                  onChanged: (Utilisateur? newValue) {
                    setState(() {
                      selectedSpecialiste = newValue!;
                    });
                  },
                  items: specialistes.map((Utilisateur specialiste) {
                    return DropdownMenuItem<Utilisateur>(
                      value: specialiste,
                      child: Text(specialiste.nom),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedEnfant != null && selectedSpecialiste != null) {
                      await assignationService.faireAssignation(
                        selectedEnfant!.id,
                        selectedSpecialiste!.id,
                        // DateTime.now(),
                      );
                      Navigator.of(context).pop(); // Ferme la boite de dialogue après l'assignation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Assignation réussie')),
                      );
                    }
                  },
                  child: const Text('Assigner'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  //Boite de suppression
Future<void> showDeleteConfirmationDialog(BuildContext context, Utilisateur utilisateur) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // L'utilisateur doit cliquer sur un bouton pour fermer le dialogue
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Voulez-vous vraiment supprimer ce Spécialiste ?'),
        actions: <Widget>[
          TextButton(

            child: Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: const Text('Annuler', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la boîte de dialogue sans supprimer
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Couleur du bouton de suppression
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Supprimer', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            onPressed: () async {
              await utilisateurService.deleteUtilisateur(utilisateur.id);
              fetchSpecialistes(); // Met à jour la liste des spécialistes
              Navigator.of(context).pop(); // Ferme la boîte de dialogue après suppression
            },
          ),
        ],
      );
    },
  );
}

  //Fin Boite de suppression

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const Text(
            "Gestion des Spécialistes",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (isLoading) // Ajoutez ceci pour afficher un indicateur de chargement
            const Center(child: CircularProgressIndicator()),
          // ignore: sized_box_for_whitespace
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: DataTable(
                // ignore: deprecated_member_use
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text("Nom", style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text("Email", style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text("Téléphone", style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text("Adresse", style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text("Spécialité", style: TextStyle(color: Colors.white))),
                  DataColumn(label: Text("Actions", style: TextStyle(color: Colors.white))),
                ],
                rows: specialistes.map((utilisateur) {
                  return buildDataRow(utilisateur, context);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildHeader() {
  return Container(
    height: 150,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(255, 88, 87, 87),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0.0, 5.0),
        )
      ],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        // Bande bleue à gauche
        Container(
          width: 8, // Largeur de la bande bleue
          color: Colors.blue, // Couleur de la bande bleue
        ),
        // Contenu principal
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Champ de recherche
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 138, 134, 134),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0.0, 5.0),
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      rechercherSpecialistes(value); // Appelle la méthode de recherche
                    },
                    decoration: const InputDecoration(
                      hintText: "Rechercher un spécialiste...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Bouton Ajouter Spécialiste
                ElevatedButton.icon(
                  onPressed: () {
                    showAddEditDialog(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Ajouter un spécialiste", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                // Bouton Assigner Spécialiste
                ElevatedButton.icon(
                  onPressed: () {
                    showAssignationDialog(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Assigner un spécialiste", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bande bleue à droite
        Container(
          width: 8, // Largeur de la bande bleue
          color: Colors.blue, // Couleur de la bande bleue
        ),
      ],
    ),
  );
}


  DataRow buildDataRow(Utilisateur utilisateur, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(utilisateur.nom)),
        DataCell(Text(utilisateur.email)),
        DataCell(Text(utilisateur.tel)),
        DataCell(Text(utilisateur.adresse)),
        DataCell(Text(utilisateur.role)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  showAddEditDialog(context, isEdit: true, utilisateurParam: utilisateur);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await  showDeleteConfirmationDialog(context, utilisateur); // Affiche la boîte de confirmation;
                  fetchSpecialistes();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAddEditDialog(BuildContext context, {bool isEdit = false, Utilisateur? utilisateurParam}) {
    if (isEdit) {
      utilisateur = utilisateurParam;
      nomController.text = utilisateur!.nom;
      emailController.text = utilisateur!.email;
      telController.text = utilisateur!.tel;
      adresseController.text = utilisateur!.adresse;
      specialite = utilisateur!.role;
      imageFile = null;
      webImageFile = null;
    } else {
      nomController.clear();
      emailController.clear();
      telController.clear();
      adresseController.clear();
      specialite = "Psychologue";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Modifier un spécialiste' : 'Ajouter un spécialiste',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(nomController, "Nom"),
                _buildTextField(emailController, "Email"),
                _buildTextField(telController, "Téléphone"),
                _buildTextField(adresseController, "Adresse"),
                const SizedBox(height: 20),
                _buildDropdown(),
                const SizedBox(height: 20),
                _buildImageSelector(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _handleAddEdit(isEdit),
                  child: Text(isEdit ? "Modifier" : "Ajouter"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<String>(
      value: specialite,
      onChanged: (String? newValue) {
        setState(() {
          specialite = newValue!;
        });
      },
      items: <String>['Psychologue', 'Orthophoniste', 'Ergothérapeute']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildImageSelector() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: selectImage,
          child: const Text("Sélectionner une image"),
        ),
        const SizedBox(width: 20),
        if (imageFile != null || webImageFile != null)
          const Text("Image sélectionnée"),
      ],
    );
  }

  Future<void> _handleAddEdit(bool isEdit) async {
    if (isEdit && utilisateur != null) {
      utilisateur = utilisateur!.copyWith(
        nom: nomController.text,
        email: emailController.text,
        tel: telController.text,
        adresse: adresseController.text,
        role: specialite,
      );

      
        if (webImageFile != null) {
          await utilisateurService.webCreateUtilisateurWithImage(utilisateur!, webImageFile!);
        } else {
          await utilisateurService.updateUtilisateur(utilisateur!);
        }
     
    } else {
      Utilisateur newUtilisateur = Utilisateur(
        id: '',
        nom: nomController.text,
        email: emailController.text,
        tel: telController.text,
        adresse: adresseController.text,
        role: specialite,
        mdp: 'defaultPassword', 
        image: '',
      );

        if (webImageFile != null) {
          await utilisateurService.webCreateUtilisateurWithImage(newUtilisateur, webImageFile!);
        } else {
          await utilisateurService.createUtilisateur(newUtilisateur);
        }
     
    }

    Navigator.of(context).pop();
    fetchSpecialistes();
  }
}

