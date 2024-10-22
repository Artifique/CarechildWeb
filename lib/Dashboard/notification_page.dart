import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController messageController = TextEditingController();
  bool isWeatherAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoyer des Notifications"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la page
            const Text(
              "Envoyer une notification aux clients",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Champ de texte pour écrire la notification
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: "Message de la notification",
                border: OutlineInputBorder(),
                hintText: "Écrivez le message ici",
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Checkbox pour alerte météo
            CheckboxListTile(
              title: const Text("Alerte Météo (Pluie dans 2 heures)"),
              value: isWeatherAlert,
              onChanged: (bool? value) {
                setState(() {
                  isWeatherAlert = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),

            // Bouton Envoyer Notification
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  sendNotification();
                },
                icon: const Icon(Icons.send),
                label: const Text("Envoyer la notification"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour envoyer la notification
  void sendNotification() {
    if (isWeatherAlert) {
      // Appel API météo pour vérifier la météo dans les deux heures
      checkWeatherAndSendAlert();
    } else {
      // Envoyer un message normal
      if (kDebugMode) {
        print("Notification envoyée : ${messageController.text}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notification envoyée avec succès !"),
        ),
      );
    }
  }

  // Fonction pour vérifier la météo avec l'API et envoyer une alerte
  void checkWeatherAndSendAlert() async {
    // Ici, vous pouvez utiliser une API météo comme OpenWeatherMap ou WeatherAPI
    // Exemple d'appel à l'API et traitement de la réponse

    // Simulons un appel API pour la pluie
    bool rainInTwoHours = true; // Remplace par le résultat de l'API

    if (rainInTwoHours) {
      if (kDebugMode) {
        print("Alerte pluie envoyée : ${messageController.text}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alerte pluie envoyée avec succès !"),
        ),
      );
    // ignore: dead_code
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pas de pluie prévue dans les deux heures."),
        ),
      );
    }
  }
}

