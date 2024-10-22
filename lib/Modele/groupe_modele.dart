class GroupeDiscussion {
  late final String idGroupe;
  final String nom;
  List<String> participantsIds; // Ajout du champ participantsIds

  GroupeDiscussion({
    required this.idGroupe,
    required this.nom,
    this.participantsIds = const [], // Initialisation par défaut
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idGroupe': idGroupe,
      'nom': nom,
      'participantsIds': participantsIds, // Ajout des participants
    };
  }

  // Créer depuis Firestore
  factory GroupeDiscussion.fromFirestore(Map<String, dynamic> data, String idGroupe) {
    return GroupeDiscussion(
      idGroupe: idGroupe,
      nom: data['nom'],
      participantsIds: List<String>.from(data['participantsIds'] ?? []), // Récupérer les participants depuis Firestore
    );
  }
}
