import 'package:accessability/Modele/creneau_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisponibiliteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un créneau de disponibilité
  Future<void> creerDisponibilite(Disponibilite disponibilite) async {
    await _firestore.collection('disponibilites').doc(disponibilite.id).set(disponibilite.toFirestore());
  }

  // Lire un créneau de disponibilité par ID
  Future<Disponibilite?> lireDisponibilite(String id) async {
    DocumentSnapshot doc = await _firestore.collection('disponibilites').doc(id).get();
    if (doc.exists) {
      return Disponibilite.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null; // Retourne null si le créneau n'existe pas
  }

  // Modifier un créneau de disponibilité
  Future<void> modifierDisponibilite(Disponibilite disponibilite) async {
    await _firestore.collection('disponibilites').doc(disponibilite.id).update(disponibilite.toFirestore());
  }

  // Supprimer un créneau de disponibilité
  Future<void> supprimerDisponibilite(String id) async {
    await _firestore.collection('disponibilites').doc(id).delete();
  }

  // Récupérer toutes les disponibilités d'un spécialiste
  Future<List<Disponibilite>> recupererDisponibilitesParSpecialiste(String specialisteId) async {
    QuerySnapshot snapshot = await _firestore.collection('disponibilites')
        .where('specialisteId', isEqualTo: specialisteId)
        .get();

    return snapshot.docs.map((doc) => Disponibilite.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }
}
