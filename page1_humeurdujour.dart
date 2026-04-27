// page 1 : entrée de l'humeur du jour en choisissant un emoji + possibilité d'entrer du texte des iamges
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Page1 extends StatefulWidget {
  const Page1({super.key});
  @override
  State<Page1> createState() => _Page1State; // enregistrer l'état de la page
}// fin Page1

class _Page1State extends State<Page1> {
  int? _indexHumeur; //int correspondant au choix de l'emoji
  final TextEditingController _noteController = TextEditingController();
  final List<XFile> _photosChoisies = [];
  final ImagePicker _picker = ImagePicker();




  final List<Map<String, dynamic>> _listeEmojis = [
    {'image': 'super.png','label': 'Super', 'color': Color(0xFFF4BC69)},
    {'image': 'bien.png','label': 'Bien', 'color': Color(0xFFF6D178)},
    {'image': 'neutre.png', 'label': 'Neutre', 'color': Color(0xFFF4DEA2) },
    {'image': 'pastop.png','label': 'pas top','color': Color(0xFF91CDD6)},
    {'image': 'mal.png','label': 'Mal','color': Color(0xFF6B99A9)}
  ]//fin listeEmojis

  Future<void> _pickImages() async{
    if(_photosChoisies.length >= 5){
      return;
    }
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return;
    setState(() {
      final int remaining = 5 - _photosChoisies.length;
      final List<XFile> toAdd = images.take(remaining).toList();
    _photosChoisies.addAll(toAdd);
    }); //fin setState

  } //fin méthode _pickImages

  void _supprimerPhoto(int index){
    setState(() {
      _photosChoisies.removeAt(index);
    });
  }//fin _supprimerPhoto

  @override
  Widget build(BuildContext context) {
    final Color couleurActuelle;
    if (_indexHumeur =! null) {
      couleurActuelle = _listeEmojis[_indexHumeur]['color'] as Color
    } //fin if
    else {
      couleurActuelle = const Color.fromARGB(0, 22, 22, 24)
    }//fin esle

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text('Comment vous sentez-vous \naujourd\'hui ?', style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w800, color: Color(0xFF000010),height: 1.15, letterSpacing: -0.5, )),

            ], //children de SingleChildScrollView
          )
        )
      )
    ) //fin Scaffhold

  }//fin build

}//fin _Page1State