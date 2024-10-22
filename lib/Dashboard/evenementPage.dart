import 'package:accessability/Services/evenement_service.dart';
import 'package:accessability/Services/recherche_sevice.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/evenement_modele.dart';

class EvenementPage extends StatefulWidget {
  const EvenementPage({super.key});

  @override
  _EvenementPageState createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> {
  final EvenementService evenementService = EvenementService();
  final TextEditingController titreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
   final TextEditingController rechercheController = TextEditingController(); 
  final RechercheService rechercheService = RechercheService();
  DateTime? dateDebut;
  DateTime? dateFin;
  TimeOfDay? heure; // Champ pour l'heure
  String parentId = 'RIEN';
  String adminId = 'userConnectedId'; // Remplacez par l'ID de l'utilisateur connecté

  List<Evenement> evenements = [];
  Evenement? evenement;

  @override
  void initState() {
    super.initState();
    fetchEvenements(); // Récupérer la liste des événements au démarrage
  }

  Future<void> fetchEvenements() async {
    try {
      List<Evenement> fetchedEvenements = await evenementService.getEvenementsByAdmin(adminId);
      setState(() {
        evenements = fetchedEvenements;
      });
    } catch (e) {
      print("Erreur lors de la récupération des événements: $e");
    }
  }
 //Boite de suppression
Future<void> showDeleteConfirmationDialog(BuildContext context, Evenement evenement) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // L'utilisateur doit cliquer sur un bouton pour fermer le dialogue
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Voulez-vous vraiment supprimer cet evenement ?'),
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
              await evenementService.deleteEvenement(evenement.id);
              fetchEvenements(); // Met à jour la liste des spécialistes
              Navigator.of(context).pop(); // Ferme la boîte de dialogue après suppression
            },
          ),
        ],
      );
    },
  );
}

  //Fin Boite de suppression

   // Méthode pour rechercher des événements
  Future<void> rechercherEvenements(String query) async {
    if (query.isEmpty) {
      // Si la recherche est vide, on récupère tous les événements
      fetchEvenements();
    } else {
      try {
        List<Evenement> resultatsRecherche = await rechercheService.rechercherEvenements(query);
        setState(() {
          evenements = resultatsRecherche;
        });
      } catch (e) {
        print("Erreur lors de la recherche des événements: $e");
      }
    }
  }

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
              "Gestion des événements",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text("Titre", style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text("Description", style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text("Date Début", style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text("Date Fin", style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text("Heure", style: TextStyle(color: Colors.white))), // Nouvelle colonne pour l'heure
                    DataColumn(label: Text("Actions", style: TextStyle(color: Colors.white))),
                  ],
                  rows: evenements.map((evenement) {
                    return buildDataRow(evenement, context);
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
                    controller: rechercheController,
                    onChanged: (value) {
                      rechercherEvenements(value); // Appelle la méthode de recherche
                    },
                    decoration: const InputDecoration(
                      hintText: "Rechercher un événement...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Bouton Ajouter Événement
                ElevatedButton.icon(
                  onPressed: () {
                    showAddEditDialog(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Ajouter un événement", style: TextStyle(color: Colors.white)),
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


  DataRow buildDataRow(Evenement evenement, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(evenement.titre)),
        DataCell(Text(evenement.description)),
        DataCell(Text(evenement.dateDebut.toLocal().toIso8601String().split('T')[0])), // Affichage de la date de début au format local
        DataCell(Text(evenement.dateFin.toLocal().toIso8601String().split('T')[0])),   // Affichage de la date de fin au format local
        DataCell(Text(evenement.heure.toLocal().toIso8601String().split('T')[1].split('.')[0])), // Affichage de l'heure

        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  showAddEditDialog(context, isEdit: true, evenementParam: evenement);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await  showDeleteConfirmationDialog(context, evenement); // Affiche la boîte de confirmation;
                  fetchEvenements();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAddEditDialog(BuildContext context, {bool isEdit = false, Evenement? evenementParam}) {
    if (isEdit) {
      evenement = evenementParam;
      titreController.text = evenement!.titre;
      descriptionController.text = evenement!.description;
      dateDebut = evenement!.dateDebut;
      dateFin = evenement!.dateFin;
      heure = TimeOfDay.fromDateTime(evenement!.heure); // Récupérer l'heure
    } else {
      titreController.clear();
      descriptionController.clear();
      dateDebut = null;
      dateFin = null;
      heure = null; // Réinitialiser l'heure
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
                  isEdit ? 'Modifier un événement' : 'Ajouter un événement',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(titreController, "Titre"),
                _buildTextField(descriptionController, "Description"),
                _buildDateSelector(context, "Date de début", (DateTime date) {
                  setState(() {
                    dateDebut = date;
                  });
                }),
                _buildDateSelector(context, "Date de fin", (DateTime date) {
                  setState(() {
                    dateFin = date;
                  });
                }),
                _buildTimeSelector(context, "Heure", (TimeOfDay time) {
                  setState(() {
                    heure = time;
                  });
                }), // Sélecteur d'heure
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

  Widget _buildDateSelector(BuildContext context, String label, Function(DateTime) onDateSelected) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: dateDebut ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: const Text("Sélectionner une date"),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context, String label, Function(TimeOfDay) onTimeSelected) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: heure ?? TimeOfDay.now(),
            );
            if (pickedTime != null) {
              onTimeSelected(pickedTime);
            }
          },
          child: const Text("Sélectionner une heure"),
        ),
      ],
    );
  }

Future<void> _handleAddEdit(bool isEdit) async {
  if (isEdit && evenement != null) {
    if (evenement!.id.isEmpty) {
      print("Erreur : L'ID de l'événement est vide.");
      return;
    }
    evenement = evenement!.copyWith(
      titre: titreController.text,
      description: descriptionController.text,
      dateDebut: dateDebut!,
      dateFin: dateFin!,
      heure: DateTime(dateDebut!.year, dateDebut!.month, dateDebut!.day, heure!.hour, heure!.minute),
    );
    await evenementService.updateEvenement(evenement!);
  } else {
    Evenement newEvenement = Evenement(
      id: '', // Laissez Firestore générer un ID
      titre: titreController.text,
      description: descriptionController.text,
      dateDebut: dateDebut!,
      dateFin: dateFin!,
      heure: DateTime(dateDebut!.year, dateDebut!.month, dateDebut!.day, heure!.hour, heure!.minute),
      parentId: parentId,
      adminId: adminId,
    );
    await evenementService.createEvenement(newEvenement);
  }
  fetchEvenements();
  Navigator.of(context).pop();
}

}
