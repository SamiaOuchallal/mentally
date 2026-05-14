import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/app_scaffold.dart';

// ── Modèle d'une note avec date ───────────────
class NoteEntry {
  final double valeur;
  final DateTime date;

  NoteEntry({required this.valeur, required this.date});

  Map<String, dynamic> toJson() => {
        'valeur': valeur,
        'date': date.toIso8601String(),
      };

  factory NoteEntry.fromJson(Map<String, dynamic> json) => NoteEntry(
        valeur: json['valeur'],
        date: DateTime.parse(json['date']),
      );
}

// ── Filtre de période ─────────────────────────
enum Periode { semaine, mois, an }

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<NoteEntry> _toutesLesNotes = [];
  Periode _periode = Periode.semaine;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  // ── Charger les notes depuis SharedPreferences ──
  Future<void> _chargerNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes_progression');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _toutesLesNotes = decoded.map((e) => NoteEntry.fromJson(e)).toList();
      });
    }
  }

  // ── Sauvegarder les notes ─────────────────────
  Future<void> _sauvegarderNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_toutesLesNotes.map((e) => e.toJson()).toList());
    await prefs.setString('notes_progression', data);
  }

  // ── Filtrer selon la période ──────────────────
  List<NoteEntry> get _notesFiltrees {
    final now = DateTime.now();
    final debut = switch (_periode) {
      Periode.semaine => now.subtract(const Duration(days: 7)),
      Periode.mois    => DateTime(now.year, now.month - 1, now.day),
      Periode.an      => DateTime(now.year - 1, now.month, now.day),
    };
    return _toutesLesNotes.where((n) => n.date.isAfter(debut)).toList();
  }

  // ── Stats ─────────────────────────────────────
  double get _moyenne {
    final notes = _notesFiltrees;
    if (notes.isEmpty) return 0;
    return notes.map((e) => e.valeur).reduce((a, b) => a + b) / notes.length;
  }

  double get _max {
    final notes = _notesFiltrees;
    if (notes.isEmpty) return 0;
    return notes.map((e) => e.valeur).reduce((a, b) => a > b ? a : b);
  }

  double get _min {
    final notes = _notesFiltrees;
    if (notes.isEmpty) return 0;
    return notes.map((e) => e.valeur).reduce((a, b) => a < b ? a : b);
  }

  // ── Ajouter une note ──────────────────────────
  void _ajouterNote() {
    final val = double.tryParse(_controller.text);
    if (val == null || val < 0 || val > 100) return;
    setState(() {
      _toutesLesNotes.add(NoteEntry(valeur: val, date: DateTime.now()));
    });
    _sauvegarderNotes();
    _controller.clear();
  }

  // ── Supprimer une note ────────────────────────
  void _supprimerNote(int index) {
    final notesFiltrees = _notesFiltrees;
    final noteASupprimer = notesFiltrees[index];
    setState(() {
      _toutesLesNotes.remove(noteASupprimer);
    });
    _sauvegarderNotes();
  }

  // ── Label de date selon la période ───────────
  String _labelDate(DateTime date) {
    return switch (_periode) {
      Periode.semaine => '${date.day}/${date.month}',
      Periode.mois    => '${date.day}/${date.month}',
      Periode.an      => '${date.month}/${date.year % 100}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notes = _notesFiltrees;
    final moy = _moyenne;

    return AppScaffold(
      title: "Progression",
      currentIndex: 1,
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Sélecteur de période ─────────────
            Row(
              children: [
                _PeriodeBtn(label: "1 semaine", selected: _periode == Periode.semaine, onTap: () => setState(() => _periode = Periode.semaine)),
                const SizedBox(width: 8),
                _PeriodeBtn(label: "1 mois",    selected: _periode == Periode.mois,    onTap: () => setState(() => _periode = Periode.mois)),
                const SizedBox(width: 8),
                _PeriodeBtn(label: "1 an",      selected: _periode == Periode.an,      onTap: () => setState(() => _periode = Periode.an)),
              ],
            ),

            const SizedBox(height: 16),

            // ── Cartes de stats ──────────────────
            Row(
              children: [
                _StatCard(label: "Moyenne", value: moy.toStringAsFixed(1), color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                _StatCard(label: "Max", value: _max.toStringAsFixed(0), color: Colors.green),
                const SizedBox(width: 8),
                _StatCard(label: "Min", value: _min.toStringAsFixed(0), color: Colors.orange),
              ],
            ),

            const SizedBox(height: 24),

            // ── Graphique ────────────────────────
            Text("Notes", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            notes.isEmpty
                ? Container(
                    height: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Aucune note sur cette période", style: TextStyle(color: Colors.grey.shade500)),
                  )
                : SizedBox(
                    height: 260,
                    child: BarChart(
                      BarChartData(
                        maxY: 110,
                        minY: 0,
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              reservedSize: 36,
                              getTitlesWidget: (val, _) => Text(
                                val.toInt().toString(),
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (val, _) {
                                final i = val.toInt();
                                if (i < 0 || i >= notes.length) return const SizedBox();
                                return Text(
                                  _labelDate(notes[i].date),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: moy,
                              color: Colors.blue,
                              strokeWidth: 2,
                              dashArray: [6, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                labelResolver: (_) => "Moy. ${moy.toStringAsFixed(1)}",
                                style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        barGroups: notes.asMap().entries.map((e) {
                          final isAbove = e.value.valeur >= moy;
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.valeur,
                                color: isAbove ? const Color(0xFF1D9E75) : const Color(0xFFD85A30),
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                              "${_labelDate(notes[group.x].date)}\n${rod.toY.toStringAsFixed(0)}",
                              const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 8),

            // ── Légende ──────────────────────────
            Row(
              children: const [
                _LegendDot(color: Color(0xFF1D9E75), label: "Au-dessus"),
                SizedBox(width: 12),
                _LegendDot(color: Color(0xFFD85A30), label: "En dessous"),
                SizedBox(width: 12),
                _LegendDot(color: Colors.blue, label: "Moyenne"),
              ],
            ),

            const SizedBox(height: 24),

            // ── Tags des notes filtrées ──────────
            if (notes.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: notes.asMap().entries.map((e) {
                  final isAbove = e.value.valeur >= moy;
                  return Chip(
                    label: Text("${_labelDate(e.value.date)} : ${e.value.valeur.toStringAsFixed(0)}"),
                    backgroundColor: isAbove
                        ? const Color(0xFF1D9E75).withOpacity(0.15)
                        : const Color(0xFFD85A30).withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: isAbove ? const Color(0xFF085041) : const Color(0xFF4A1B0C),
                      fontSize: 12,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => _supprimerNote(e.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // ── Ajouter une note ─────────────────
            Text("Ajouter une note", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Note (0–100)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _ajouterNote(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _ajouterNote,
                  child: const Text("Ajouter"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bouton période ────────────────────────────
class _PeriodeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodeBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Widget carte stat ─────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: color)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Widget légende ────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
