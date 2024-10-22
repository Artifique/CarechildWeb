class Disponibilite {
  final String id; // Identifiant unique pour chaque disponibilité
  final String specialisteId; // ID du spécialiste associé
  final List<String> joursDisponibilite; // Jours disponibles, par exemple ['Lundi', 'Mardi']
  final List<Horaire> horaires; // Liste des horaires de disponibilité
  final int nombreConsultationsMax; // Nombre maximum de consultations par jour

  Disponibilite({
    required this.id,
    required this.specialisteId,
    required this.joursDisponibilite,
    required this.horaires,
    required this.nombreConsultationsMax,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'specialisteId': specialisteId,
      'joursDisponibilite': joursDisponibilite,
      'horaires': horaires.map((h) => h.toFirestore()).toList(),
      'nombreConsultationsMax': nombreConsultationsMax,
    };
  }

  factory Disponibilite.fromFirestore(Map<String, dynamic> data) {
    return Disponibilite(
      id: data['id'],
      specialisteId: data['specialisteId'],
      joursDisponibilite: List<String>.from(data['joursDisponibilite']),
      horaires: List<Horaire>.from(data['horaires'].map((h) => Horaire.fromFirestore(h))),
      nombreConsultationsMax: data['nombreConsultationsMax'],
    );
  }
}

class Horaire {
  final String heureDebut; // Heure de début, format 'HH:mm'
  final String heureFin; // Heure de fin, format 'HH:mm'

  Horaire({
    required this.heureDebut,
    required this.heureFin,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'heureDebut': heureDebut,
      'heureFin': heureFin,
    };
  }

  factory Horaire.fromFirestore(Map<String, dynamic> data) {
    return Horaire(
      heureDebut: data['heureDebut'],
      heureFin: data['heureFin'],
    );
  }
}
