import 'package:cloud_firestore/cloud_firestore.dart';

class RendezVous {
  late final String idRendezVous;
  final DateTime date;
  final DateTime heure;
  final String status;
  final String idSpecialiste;
  final String motif;

  RendezVous({
    required this.idRendezVous,
    required this.date,
    required this.heure,
    required this.status,
    required this.idSpecialiste,
    required this.motif,
  });

  // Convertir un rendez-vous en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idRendezVous': idRendezVous,
      'date': date,
      'heure': heure,
      'status': status,
      'idSpecialiste': idSpecialiste,
      'motif': motif,
    };
  }

  // Créer un rendez-vous depuis Firestore
  factory RendezVous.fromFirestore(Map<String, dynamic> data, String idRendezVous) {
    return RendezVous(
      idRendezVous: idRendezVous,
      date: (data['date'] as Timestamp).toDate(),
      heure: (data['heure'] as Timestamp).toDate(),
      status: data['status'],
      idSpecialiste: data['idSpecialiste'],
      motif: data['motif'],
    );
  }
}
