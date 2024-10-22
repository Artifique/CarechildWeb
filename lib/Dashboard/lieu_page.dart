// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:accessability/Modele/lieu_modele.dart';
import 'package:accessability/Services/lieu_service.dart';

class LieuxPage extends StatefulWidget {
  const LieuxPage({super.key});

  @override
  _LieuxPageState createState() => _LieuxPageState();
}

class _LieuxPageState extends State<LieuxPage> {
  final LieuService _lieuService = LieuService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _accessibility = "Accessible";

  List<Lieu> _lieux = [];

  @override
  void initState() {
    super.initState();
    _loadLieux();
  }

  Future<void> _loadLieux() async {
    final lieux = await _lieuService.getAllLieux();
    setState(() {
      _lieux = lieux;
    });
  }

  void _showAddEditDialog({Lieu? lieu}) {
    if (lieu != null) {
      _nameController.text = lieu.nom;
      _locationController.text = lieu.adresse;
      _accessibility = lieu.accessibilite;
    } else {
      _nameController.clear();
      _locationController.clear();
      _accessibility = "Accessible";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lieu == null ? 'Ajouter un lieu' : 'Modifier un lieu',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nom du lieu"),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Emplacement"),
                ),
                DropdownButton<String>(
                  value: _accessibility,
                  onChanged: (String? newValue) {
                    setState(() {
                      _accessibility = newValue!;
                    });
                  },
                  items: <String>['Accessible', 'Non accessible']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (lieu == null) {
                          // Ajouter un nouveau lieu
                          final newLieu = Lieu(
                            id: '',
                            nom: _nameController.text,
                            adresse: _locationController.text,
                            accessibilite: _accessibility,
                          );
                          await _lieuService.createLieu(newLieu);
                        } else {
                          // Modifier un lieu existant
                          final updatedLieu = Lieu(
                            id: lieu.id,
                            nom: _nameController.text,
                            adresse: _locationController.text,
                            accessibilite: _accessibility,
                          );
                          await _lieuService.updateLieu(lieu.id, updatedLieu);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        _loadLieux();
                      },
                      child: Text(lieu == null ? "Ajouter" : "Modifier"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteLieu(String id) async {
    await _lieuService.deleteLieu(id);
    _loadLieux();
  }

  DataRow _buildDataRow(Lieu lieu) {
    return DataRow(
      cells: [
        DataCell(Text(lieu.nom)),
        DataCell(Text(lieu.adresse)),
        DataCell(Text(lieu.accessibilite)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () => _showAddEditDialog(lieu: lieu),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteLieu(lieu.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
    
      body:
       Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 155,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 88, 87, 87),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 138, 134, 134),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "Ajouter un lieu",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gestion des Lieux Accessibles",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      
                      // ignore: deprecated_member_use
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text("Nom du lieu", style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text("Emplacement", style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text("Accessibilité", style: TextStyle(color: Colors.white))),
                        DataColumn(label: Text("Actions", style: TextStyle(color: Colors.white))),
                      ],
                      rows: _lieux.map(_buildDataRow).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
