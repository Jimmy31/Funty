"""Découpe docs/graphics/Coupes.png en trois badges détourés, un par niveau de
récompense (cf. PRD 6.7), écrits dans assets/images/badges/.

L'illustration source aligne les trois coupes sur fond blanc, dans l'ordre
or (1), argent (2), bronze (3).

Deux points méritent une explication :

- **Détourage par région connexe, pas par seuil global.** Un simple « tout ce
  qui est blanc devient transparent » troue les coupes de l'intérieur : la
  plaque de la coupe d'argent est blanche, et le corps argenté frôle le blanc
  sur ses reflets. On ne rend donc transparente que la zone blanche *reliée
  au bord de l'image*, en laissant intacts les blancs enfermés dans un dessin.

- **Alpha progressif sur le pourtour.** Le dessin est anticrénelé : ses pixels
  de bord sont des mélanges de la coupe et du fond. Les rendre opaques laisse
  un liseré blanc très visible sur le fond lavande de l'application. L'alpha
  suit donc une rampe entre BLANC_SUR et BLANC_FLOU, ce qui reconstitue un
  bord net à n'importe quelle taille d'affichage.
"""

import numpy as np
from PIL import Image
from scipy import ndimage

SOURCE = "docs/graphics/Coupes.png"
DESTINATION = "assets/images/badges"

# De gauche à droite dans l'illustration source.
NIVEAUX = ["or", "argent", "bronze"]

# Un pixel au-dessus de BLANC_SUR est du fond franc ; en dessous de BLANC_FLOU
# il appartient au dessin. Entre les deux, c'est un bord anticrénelé.
BLANC_SUR = 250
BLANC_FLOU = 232

TAILLE = 512
MARGE = 0.04

# L'illustration source porte quelques poussières d'anticrénelage isolées
# (une tache de 5 pixels contre l'anse de la coupe d'or) : sans ce filtre,
# elles passent pour une quatrième coupe au moment du découpage.
TACHE_MAX = 200

# Aire à partir de laquelle une zone blanche fermée est un ajour d'anse et non
# un chiffre gravé (cf. alpha_du_fond).
AJOUR_MIN = 2000


def alpha_du_fond(rgb: np.ndarray) -> np.ndarray:
    """Alpha 0-255 : transparent sur le fond et dans les ajours des anses."""
    # En float : les canaux sont des uint8, et un « 250 - 255 » y reboucle à
    # 251 au lieu de donner -5, ce qui rendait la rampe ci-dessous opaque
    # partout, fond compris.
    canal_min = rgb.min(axis=2).astype(float)

    regions, total = ndimage.label(canal_min >= BLANC_FLOU)
    etiquettes = range(1, total + 1)

    # Le fond proprement dit : la région blanche qui touche le bord.
    bord = np.concatenate(
        [regions[0, :], regions[-1, :], regions[:, 0], regions[:, -1]]
    )
    exterieur = np.unique(bord[bord > 0])

    # Les ajours des anses sont enfermés dans le dessin, donc invisibles pour
    # le test ci-dessus, mais doivent être transparents eux aussi. Deux
    # critères les séparent des blancs à conserver : ils sont d'un blanc franc
    # (le chiffre gravé et la plaque tirent sur le blanc cassé) et nettement
    # plus vastes (≈ 4 100 px contre ≤ 1 510 px pour un chiffre).
    aires = ndimage.sum_labels(np.ones_like(canal_min), regions, etiquettes)
    blancheur = ndimage.median(canal_min, regions, etiquettes)
    ajours = np.array(
        [
            e
            for e in etiquettes
            if e not in exterieur
            and aires[e - 1] >= AJOUR_MIN
            and blancheur[e - 1] >= BLANC_SUR
        ],
        dtype=exterieur.dtype,
    )

    fond = np.isin(regions, np.concatenate([exterieur, ajours]))

    rampe = (BLANC_SUR - canal_min) / (BLANC_SUR - BLANC_FLOU)
    return np.where(fond, np.clip(rampe, 0, 1) * 255, 255).astype(np.uint8)


def sans_taches(opaque: np.ndarray) -> np.ndarray:
    """Efface les amas opaques trop petits pour faire partie d'un dessin."""
    amas, total = ndimage.label(opaque)
    tailles = ndimage.sum_labels(opaque, amas, range(1, total + 1))
    garde = np.concatenate([[False], tailles >= TACHE_MAX])
    return garde[amas]


def colonnes_des_coupes(opaque: np.ndarray, nombre: int) -> list[tuple[int, int]]:
    """Bornes horizontales de chaque coupe, séparées par les colonnes vides."""
    occupee = opaque.any(axis=0)
    groupes, total = ndimage.label(occupee)
    assert total == nombre, f"{total} coupes détectées au lieu de {nombre}"
    return [
        (int(np.flatnonzero(groupes == i)[0]), int(np.flatnonzero(groupes == i)[-1]))
        for i in range(1, total + 1)
    ]


def carre(image: Image.Image) -> Image.Image:
    """Recadre sur le dessin, puis centre dans un carré transparent."""
    image = image.crop(image.getbbox())
    cote = int(max(image.size) * (1 + 2 * MARGE))
    fond = Image.new("RGBA", (cote, cote), (0, 0, 0, 0))
    fond.paste(image, ((cote - image.width) // 2, (cote - image.height) // 2))
    return fond.resize((TAILLE, TAILLE), Image.LANCZOS)


def main() -> None:
    source = Image.open(SOURCE).convert("RGBA")
    rgb = np.array(source)[:, :, :3]
    alpha = alpha_du_fond(rgb)
    alpha = np.where(sans_taches(alpha > 8), alpha, 0).astype(np.uint8)

    detouree = Image.fromarray(np.dstack([rgb, alpha]), "RGBA")

    for niveau, (gauche, droite) in zip(
        NIVEAUX, colonnes_des_coupes(alpha > 8, len(NIVEAUX))
    ):
        coupe = detouree.crop((gauche, 0, droite + 1, source.height))
        chemin = f"{DESTINATION}/badge_{niveau}.png"
        carre(coupe).save(chemin)
        print(f"{chemin} écrit")


if __name__ == "__main__":
    main()
