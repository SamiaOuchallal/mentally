import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../services/notifications_services.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Paramètres",
      currentIndex: 4,
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
            break;
        }
      },
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle("Profil utilisateur >"),
          ListTile(
            leading: const Icon(Icons.notification_add),
            title: const Text("Tester une notification"),
            onTap: () async {
              await NotificationService().showTestNotification();
            },
          ),

          _SettingsTile(
            title: "Nom / pseudo",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Age ou tranche d'âge",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Genre (optionnel)",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Niveau de stress (auto-évaluation)",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Habitudes (sport, sommeil, etc.)",
            subtitle: "blabla",
            onTap: () {},
          ),

          const SizedBox(height: 25),

          _SectionTitle("Notifications & rappels >"),
          _SettingsTile(
            title: "Activer / désactiver les notifications",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Fréquence des rappels",
            subtitle: "(1x/jour, 3x/semaine....)",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Types de rappels",
            subtitle: "méditation et check émotionnel",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Horaires personnalisées",
            subtitle: "blabla",
            onTap: () {},
          ),

          const SizedBox(height: 25),

          _SectionTitle("Apparence >"),
          _SettingsTile(
            title: "Mode sombre / clair",
            subtitle: "Personnalisation du thème",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Taille du texte",
            subtitle: "Normal, grand, très grand",
            onTap: () {},
          ),

          const SizedBox(height: 25),

          _SectionTitle("Confidentialité & données >"),
          _SettingsTile(
            title: "Gestion des données personnelles",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Export des données",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Partage des données",
            subtitle: "oui ou non",
            onTap: () {},
          ),

          const SizedBox(height: 25),

          _SectionTitle("Objectifs & progression >"),
          _SettingsTile(
            title: "Définir des objectifs personnalisés",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Suivi des progrès",
            subtitle: "blabla",
            onTap: () {},
          ),
          _SettingsTile(
            title: "Réinitialisation des objectifs",
            subtitle: "blabla",
            onTap: () {},
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ---------------------------------------------------------
// TILE AVEC ICÔNE + TITRE + SOUS-TITRE + FLÈCHE
// ---------------------------------------------------------
class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 28, color: AppColors.blueNight),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
