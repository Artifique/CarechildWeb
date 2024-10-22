import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RendezVousService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un rendez-vous
  Future<void> creerRendezVous(RendezVous rendezVous) async {
    await _firestore.collection('rendezVous').doc(rendezVous.idRendezVous).set(rendezVous.toFirestore());
  }

  // Modifier un rendez-vous
  Future<void> modifierRendezVous(RendezVous rendezVous) async {
    await _firestore.collection('rendezVous').doc(rendezVous.idRendezVous).update(rendezVous.toFirestore());
  }

  // Annuler un rendez-vous
  Future<void> annulerRendezVous(String idRendezVous) async {
    await _firestore.collection('rendezVous').doc(idRendezVous).delete();
  }

  // Récupérer tous les rendez-vous d'un utilisateur
  Future<List<RendezVous>> recupererRendezVous(String idUtilisateur) async {
    QuerySnapshot snapshot = await _firestore
        .collection('rendezVous')
        .where('idUtilisateur', isEqualTo: idUtilisateur) // Assurez-vous d'ajouter cette logique si nécessaire
        .get();
    
    return snapshot.docs.map((doc) {
      return RendezVous.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
