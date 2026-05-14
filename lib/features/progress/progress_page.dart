import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../widgets/app_scaffold.dart';

// ─────────────────────────────────────────────
//  Modifie cette liste avec tes vraies notes !
// ─────────────────────────────────────────────
const List<double> notes = [72, 85, 61, 90, 78, 55, 88];

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final List<double> _notes = List.from(notes);
  final TextEditingController _controller = TextEditingController();

  // ── Calcul de la moyenne ──────────────────
  double get _moyenne =>
      _notes.isEmpty ? 0 : _notes.reduce((a, b) => a + b) / _notes.length;

  double get _max => _notes.isEmpty ? 0 : _notes.reduce((a, b) => a > b ? a : b);
  double get _min => _notes.isEmpty ? 0 : _notes.reduce((a, b) => a < b ? a : b);

  // ── Ajouter une note ──────────────────────
  void _ajouterNote() {
    final val = double.tryParse(_controller.text);
    if (val == null || val < 0 || val > 100) return;
    setState(() => _notes.add(val));
    _controller.clear();
  }

  // ── Supprimer une note ────────────────────
  void _supprimerNote(int index) {
    setState(() => _notes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

            // ── Cartes de stats ──────────────
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

            // ── Graphique ────────────────────
            Text("Notes", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _notes.isEmpty
                ? const Center(child: Text("Aucune note ajoutée"))
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
                              getTitlesWidget: (val, _) => Text(
                                "N${(val + 1).toInt()}",
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        // Ligne de moyenne
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
                        barGroups: _notes.asMap().entries.map((e) {
                          final isAbove = e.value >= moy;
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: isAbove ? const Color(0xFF1D9E75) : const Color(0xFFD85A30),
                                width: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                              "Note ${group.x + 1}\n${rod.toY.toStringAsFixed(0)}",
                              const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 8),

            // ── Légende ──────────────────────
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

            // ── Tags des notes ───────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _notes.asMap().entries.map((e) {
                final isAbove = e.value >= moy;
                return Chip(
                  label: Text("Note ${e.key + 1} : ${e.value.toStringAsFixed(0)}"),
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

            // ── Ajouter une note ─────────────
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
