import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';

class RessourceService {
  final CollectionReference ressourcesCollection =
      FirebaseFirestore.instance.collection('ressources');
  final FirebaseStorage storage = FirebaseStorage.instance;

  FlutterSoundRecorder? _audioRecorder;
  bool isRecording = false;

  // Initialisation de l'enregistreur
  void initRecorder() {
    _audioRecorder = FlutterSoundRecorder();
  }

  // Méthode pour démarrer l'enregistrement vocal
  Future<void> startRecording() async {
    try {
      if (_audioRecorder != null) {
        // Initialiser la session audio
        await _audioRecorder!.openRecorder();

        // Demander la permission d'accès au micro
        await _audioRecorder!.setSubscriptionDuration(Duration(milliseconds: 10));

        // Démarrer l'enregistrement
        await _audioRecorder!.startRecorder(toFile: 'audioRecording.aac');
        isRecording = true;
        print('Enregistrement commencé...');
      }
    } catch (e) {
      print('Erreur lors du démarrage de l\'enregistrement: $e');
    }
  }

  // Méthode pour arrêter l'enregistrement vocal et sauvegarder le fichier
  Future<String> stopRecording() async {
    try {
      if (_audioRecorder != null && isRecording) {
        // Arrêter l'enregistrement
        String? filePath = await _audioRecorder!.stopRecorder();
        isRecording = false;
        print('Enregistrement arrêté, fichier enregistré sous $filePath');

        // Lire le fichier audio en tant que Uint8List
        final fileBytes = await _readFileAsBytes(filePath!);

        // Uploader le fichier audio dans Firebase Storage
        String audioUrl = await _uploadBlobFile(blob: html.Blob([Uint8List.fromList(fileBytes)]), folderName: 'audios');
        print('Fichier audio uploadé avec succès.');

        return audioUrl;
      } else {
        throw Exception('Enregistrement non démarré.');
      }
    } catch (e) {
      print('Erreur lors de l\'arrêt de l\'enregistrement: $e');
      return '';
    }
  }

  // Utilise FileReader pour lire un fichier en tant que bytes
  Future<Uint8List> _readFileAsBytes(String filePath) async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();

    reader.onLoadEnd.listen((e) {
      completer.complete(reader.result as Uint8List);
    });

    // Le chemin de fichier est converti en un `Blob`
    final fileBlob = html.Blob([filePath]);
    reader.readAsArrayBuffer(fileBlob);

    return completer.future;
  }

  // Méthode pour uploader un Blob (enregistrement vocal)
  Future<String> _uploadBlobFile({required html.Blob blob, required String folderName}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = storage.ref().child('$folderName/$fileName');

    // Utilisation de `putData` avec `Uint8List` obtenu à partir de `FileReader`
    UploadTask uploadTask = storageRef.putData(Uint8List.fromList(await _blobToBytes(blob)));
    TaskSnapshot snapshot = await uploadTask;

    // Récupérer l'URL du fichier uploadé
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Méthode pour convertir un Blob en bytes
  Future<List<int>> _blobToBytes(html.Blob blob) async {
    final completer = Completer<List<int>>();
    final reader = html.FileReader();

    reader.onLoadEnd.listen((e) {
      completer.complete(reader.result as List<int>);
    });

    reader.readAsArrayBuffer(blob);

    return completer.future;
  }

  // Méthode pour créer une ressource
  Future<void> createRessource({
    required String titre,
    required String description,
    required String transcriptionTexte,
    required String audioUrl, // URL de l'audio enregistré
    required html.File imageFile, // Fichier image sur le web
    required String idAdmin,
    String idParent = 'RIEN',
  }) async {
    try {
      // 1. Uploader l'image et obtenir son URL
      String imageUrl = await _uploadFile(
        file: imageFile,
        folderName: 'images',
      );

      // 2. Créer le document Ressource dans Firestore
      DocumentReference docRef = await ressourcesCollection.add({
        'titre': titre,
        'description': description,
        'vocal': audioUrl, // Utiliser l'URL de l'audio enregistré
        'transcriptionTexte': transcriptionTexte,
        'imageRepresentation': imageUrl,
        'idAdmin': idAdmin,
        'idParent': idParent,
      });

      // Ajouter l'idRessource au document
      await docRef.update({'idRessource': docRef.id});
    } catch (e) {
      print('Erreur lors de la création de la ressource: $e');
    }
  }

  // Méthode pour uploader un fichier dans Firebase Storage
  Future<String> _uploadFile({required html.File file, required String folderName}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = storage.ref().child('$folderName/$fileName');

    // Utilisation de `html.File` pour le téléchargement
    UploadTask uploadTask = storageRef.putBlob(file);
    TaskSnapshot snapshot = await uploadTask;

    // Récupérer l'URL du fichier uploadé
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
