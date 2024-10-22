// ignore_for_file: avoid_web_libraries_in_flutter, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:html' as html;
import 'package:accessability/Services/ressource_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class RessourceDash extends StatefulWidget {
  @override
  _RessourceDashState createState() => _RessourceDashState();
}

class _RessourceDashState extends State<RessourceDash> {
  final _formKey = GlobalKey<FormState>();
  String titre = '';
  String description = '';
  String transcriptionTexte = '';
  html.File? imageFile;
  String audioUrl = '';
  bool isRecording = false;
  // ignore: prefer_final_fields
  RessourceService _ressourceService = RessourceService();

  @override
  void initState() {
    super.initState();
    _ressourceService.initRecorder();  // Initialize the recorder from the service
  }

  // Fonction pour démarrer l'enregistrement vocal
  void startRecording() async {
    setState(() {
      isRecording = true;
    });
    try {
      await _ressourceService.startRecording();
    } catch (e) {
      print('Erreur lors du démarrage de l\'enregistrement: $e');
    }
  }

  // Fonction pour arrêter l'enregistrement vocal
  void stopRecording() async {
    try {
      String url = await _ressourceService.stopRecording();
      setState(() {
        isRecording = false;
        audioUrl = url;  // Mettre à jour l'URL audio après l'enregistrement
      });
    } catch (e) {
      print('Erreur lors de l\'arrêt de l\'enregistrement: $e');
    }
  }

  // Fonction pour sélectionner une image
  Future<void> pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      setState(() {
        imageFile = files[0];
      });
    });
  }

  // Fonction pour soumettre le formulaire et créer la ressource
  Future<void> submitForm() async {
    if (_formKey.currentState!.validate() && imageFile != null && audioUrl.isNotEmpty) {
      try {
        // Appel au service pour créer la ressource
        await _ressourceService.createRessource(
          titre: titre,
          description: description,
          transcriptionTexte: transcriptionTexte,
          audioUrl: audioUrl,  // URL de l'audio enregistré
          imageFile: imageFile!,  // Passe l'image sélectionnée
          idAdmin: 'admin123',  // Remplacez par l'ID réel de l'administrateur
        );
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ressource créée avec succès')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de la création de la ressource')));
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une Ressource'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Titre'),
                onChanged: (value) {
                  setState(() {
                    titre = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Transcription'),
                onChanged: (value) {
                  setState(() {
                    transcriptionTexte = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: isRecording ? null : startRecording,
                    child: Text(isRecording ? 'Enregistrement en cours...' : 'Démarrer l\'enregistrement'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isRecording ? stopRecording : null,
                    child: Text('Arrêter l\'enregistrement'),
                  ),
                ],
              ),
              if (audioUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Audio enregistré avec succès!'),
                ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text(imageFile == null ? 'Choisir une image' : 'Image sélectionnée'),
                  ),
                  if (imageFile != null)
                    Text(
                      ' (${imageFile!.name})',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Créer la ressource'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
