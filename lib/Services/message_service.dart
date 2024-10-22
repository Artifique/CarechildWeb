import 'package:accessability/Modele/groupe_modele.dart';
import 'package:accessability/Modele/message_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un groupe de discussion avec une clé générée automatiquement
  Future<void> creerGroupe(String nom, List<String> participantsIds) async {
    String idGroupe = _firestore.collection('groupes').doc().id; // Générer une clé unique
    GroupeDiscussion groupe = GroupeDiscussion(
      idGroupe: idGroupe,
      nom: nom,
      participantsIds: participantsIds, // Ajouter les participants lors de la création
    );

    // Enregistrer le groupe dans Firestore
    await _firestore.collection('groupes').doc(idGroupe).set(groupe.toFirestore());
  }

  // Envoyer un message
  Future<void> envoyerMessage(String emetteurId, String recepteurId, String contenu, {String? idGroupe}) async {
    // Créer un nouvel ID pour le message
    String idMessage = _firestore.collection('messages').doc().id; 
    Message message = Message(
      idMessage: idMessage,
      contenu: contenu,
      dateEnvoi: DateTime.now(),
      emetteurId: emetteurId,
      recepteurId: recepteurId,
      idGroupe: idGroupe,
    );

    // Enregistrer le message dans Firestore
    await _firestore.collection('messages').doc(idMessage).set(message.toFirestore());
  }

  // Recevoir tous les messages d'un groupe
  Stream<List<Message>> recevoirMessages(String idGroupe) {
    return _firestore
        .collection('messages')
        .where('idGroupe', isEqualTo: idGroupe)
        .orderBy('dateEnvoi')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }

  // Ajouter un participant à un groupe
  Future<void> ajouterParticipant(String idGroupe, String participantId) async {
    // Récupérer le groupe existant
    DocumentSnapshot groupeSnapshot = await _firestore.collection('groupes').doc(idGroupe).get();
    
    if (groupeSnapshot.exists) {
      // Mettre à jour les participants du groupe
      GroupeDiscussion groupe = GroupeDiscussion.fromFirestore(groupeSnapshot.data() as Map<String, dynamic>, idGroupe);
      groupe.participantsIds.add(participantId); // Ajouter le nouvel ID du participant

      // Enregistrer la mise à jour dans Firestore
      await _firestore.collection('groupes').doc(idGroupe).update({'participantsIds': groupe.participantsIds});
    }
  }

  // Recevoir tous les participants d'un groupe
  Future<List<String>> recevoirParticipants(String idGroupe) async {
    DocumentSnapshot groupeSnapshot = await _firestore.collection('groupes').doc(idGroupe).get();
    if (groupeSnapshot.exists) {
      GroupeDiscussion groupe = GroupeDiscussion.fromFirestore(groupeSnapshot.data() as Map<String, dynamic>, idGroupe);
      return groupe.participantsIds;
    }
    return [];
  }

  // Supprimer un groupe
  Future<void> supprimerGroupe(String idGroupe) async {
    // Supprimer tous les messages associés au groupe
    final messagesSnapshot = await _firestore.collection('messages').where('idGroupe', isEqualTo: idGroupe).get();
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
    
    // Supprimer le groupe
    await _firestore.collection('groupes').doc(idGroupe).delete();
  }

  // Supprimer un message
  Future<void> supprimerMessage(String idMessage) async {
    await _firestore.collection('messages').doc(idMessage).delete();
  }

  Future<List<Utilisateur>> getDiscussions(String? currentUserId) async {
    try {
      // Récupérer tous les messages où l'utilisateur est soit émetteur, soit récepteur
      QuerySnapshot messageSnapshot = await _firestore
          .collection('messages')
          .where('emetteurId', isEqualTo: currentUserId)
          .get();

      QuerySnapshot messageSnapshotRecepteur = await _firestore
          .collection('messages')
          .where('recepteurId', isEqualTo: currentUserId)
          .get();

      Set<String> userIds = {};

      // Ajouter tous les récepteurs des messages envoyés par l'utilisateur
      messageSnapshot.docs.forEach((doc) {
        userIds.add(doc['recepteurId']);
      });

      // Ajouter tous les émetteurs des messages reçus par l'utilisateur
      messageSnapshotRecepteur.docs.forEach((doc) {
        userIds.add(doc['emetteurId']);
      });

      // Récupérer les utilisateurs à partir de leurs IDs, excluant l'utilisateur courant
      List<Utilisateur> utilisateurs = [];
      for (String userId in userIds) {
        if (userId != currentUserId) { // Exclure l'utilisateur courant
          Utilisateur? utilisateur = await UtilisateurService().getUtilisateurById(userId);
          if (utilisateur != null) {
            utilisateurs.add(utilisateur);
          }
        }
      }

      return utilisateurs;
    } catch (e) {
      print('Erreur lors de la récupération des discussions : $e');
      return [];
    }
  }
}
