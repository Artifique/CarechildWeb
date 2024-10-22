class Ressource {
  String idRessource;     // Identifiant unique de la ressource
  String titre;           // Titre de la ressource
  String description;     // Description de la ressource
  String vocal;           // URL ou chemin vers le fichier audio
  String transcriptionTexte; // Texte de la transcription de l'audio
  String imageRepresentation; // URL ou chemin vers l'image représentative
  String idAdmin;         // Référence à l'Admin qui a créé la ressource
  String idParent;        // Référence à un parent si applicable (optionnel)

  // Constructeur
  Ressource({
    required this.idRessource,
    required this.titre,
    required this.description,
    required this.vocal,
    required this.transcriptionTexte,
    required this.imageRepresentation,
    required this.idAdmin,
    this.idParent = 'RIEN',   // Le champ idParent est optionnel et a une valeur par défaut 'RIEN'
  });

  // Méthode pour convertir l'objet en JSON pour stockage dans Firebase
  Map<String, dynamic> toJson() {
    return {
      'idRessource': idRessource,
      'titre': titre,
      'description': description,
      'vocal': vocal,
      'transcriptionTexte': transcriptionTexte,
      'imageRepresentation': imageRepresentation,
      'idAdmin': idAdmin,
      'idParent': idParent,   // Peut être 'RIEN' si la ressource n'est pas liée à un parent
    };
  }

  // Méthode pour créer un objet Ressource à partir de données JSON
  factory Ressource.fromJson(Map<String, dynamic> json) {
    return Ressource(
      idRessource: json['idRessource'],
      titre: json['titre'],
      description: json['description'],
      vocal: json['vocal'],
      transcriptionTexte: json['transcriptionTexte'],
      imageRepresentation: json['imageRepresentation'],
      idAdmin: json['idAdmin'],
      idParent: json['idParent'] ?? 'RIEN',   // Valeur par défaut si idParent n'est pas fourni
    );
  }
}
