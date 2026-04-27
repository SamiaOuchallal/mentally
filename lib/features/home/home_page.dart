import 'package:flutter/material.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../../../widgets/app_button.dart';
import '../../../../theme/app_typo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Mentally",
      currentIndex: 0, // onglet sélectionné
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/progress');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/calendar');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/videos');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Bienvenue 👋")],
      ),
    );
  }
}
