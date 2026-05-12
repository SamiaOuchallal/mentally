import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

# ────────────────────────────────────────────────
#  TES NOTES  →  Modifie cette liste !
# ────────────────────────────────────────────────
notes = [10, 12, 14, 16, 18, 20, 22]
labels = [f"jour {i+1}" for i in range(len(notes))]

# ────────────────────────────────────────────────
#  CALCUL DE LA MOYENNE
# ────────────────────────────────────────────────
moyenne = sum(notes) / len(notes)
note_max = max(notes)
note_min = min(notes)

print(f"📊 Moyenne  : {moyenne:.1f}")
print(f"⬆  Note max : {note_max}")
print(f"⬇  Note min : {note_min}")

# ────────────────────────────────────────────────
#  COULEURS  (vert = au-dessus, orange = en dessous)
# ────────────────────────────────────────────────
couleurs = ["#1D9E75" if n >= moyenne else "#D85A30" for n in notes]

# ────────────────────────────────────────────────
#  FIGURE
# ────────────────────────────────────────────────
fig, ax = plt.subplots(figsize=(10, 5))
fig.patch.set_facecolor("#F5F4F0")
ax.set_facecolor("#FFFFFF")

# Barres
x = np.arange(len(notes))
bars = ax.bar(x, notes, color=couleurs, width=0.55, zorder=3)

# Valeur au-dessus de chaque barre
for bar, note in zip(bars, notes):
    ax.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 1.2,
        str(note),
        ha="center", va="bottom",
        fontsize=11, fontweight="600", color="#1a1a18"
    )

# Ligne de moyenne
ax.axhline(moyenne, color="#378ADD", linewidth=2,
           linestyle="--", zorder=4, label=f"Moyenne : {moyenne:.1f}")

# Annotation de la ligne
ax.text(len(notes) - 0.5, moyenne + 1.5,
        f"  Moy. {moyenne:.1f}",
        color="#378ADD", fontsize=10, fontweight="600", va="bottom")

# ────────────────────────────────────────────────
#  MISE EN FORME
# ────────────────────────────────────────────────
ax.set_xticks(x)
ax.set_xticklabels(labels, fontsize=11)
ax.set_ylim(0, 110)
ax.set_ylabel("Note", fontsize=11, color="#888780")
ax.set_title("Graphique de moyenne", fontsize=15,
             fontweight="600", pad=16, color="#1a1a18")

# Grille discrète
ax.yaxis.grid(True, color="#E0DDD8", linewidth=0.8, zorder=0)
ax.set_axisbelow(True)
ax.spines[["top", "right", "left"]].set_visible(False)
ax.spines["bottom"].set_color("#E0DDD8")
ax.tick_params(colors="#888780")

# Légende
patch_above = mpatches.Patch(color="#1D9E75", label="Au-dessus de la moyenne")
patch_below = mpatches.Patch(color="#D85A30", label="En dessous de la moyenne")
patch_avg   = mpatches.Patch(color="#378ADD", label=f"Moyenne ({moyenne:.1f})")
ax.legend(handles=[patch_above, patch_below, patch_avg],
          loc="upper right", framealpha=0.9, fontsize=10)

plt.tight_layout()
plt.savefig("graphique_moyenne.png", dpi=150, bbox_inches="tight",
            facecolor=fig.get_facecolor())
print(" Image sauvegardée : graphique_moyenne.png")
plt.show()
