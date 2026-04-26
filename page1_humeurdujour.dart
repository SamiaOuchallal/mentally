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
  final List<XFile> _imagesChoisies = [];
  final ImagePicker _picker = ImagePicker();

}//fin _Page1State
