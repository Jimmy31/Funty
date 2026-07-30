"""Fabrique les trois sources d'icône de assets/icon/ à partir de
docs/graphics/icone.png (la grenouille à lunettes du thème de récompense,
cf. PRD 6.7), puis `dart run flutter_launcher_icons` génère les mipmaps.

Deux réglages sont issus d'essais sur appareil et méritent une explication :

- **Recadrage.** L'illustration d'origine laisse une large marge bleue autour
  du dessin, qui rendait la grenouille minuscule dans l'icône. On recadre donc
  sur son cadre englobant, avec 12 % de marge — assez serré pour remplir
  l'icône, assez large pour que les masques ronds ne mordent pas dans le
  visage. Le centre du recadrage est descendu de quelques pixels sous le
  centre du dessin, ce qui *remonte* la grenouille dans l'icône : sa masse
  visuelle est dans le bas (corps et bouche), le dessin brut paraît donc posé
  trop bas une fois masqué.

- **Arrière-plan adaptatif uni.** Il ne doit porter aucun motif : One UI ne met
  pas les calques avant-plan et arrière-plan à la même échelle, et y remettre
  l'illustration affiche deux grenouilles superposées de tailles différentes.
"""

from PIL import Image
import numpy as np

SIZE = 1024
SOURCE = 'docs/graphics/icone.png'
OUT = 'assets/icon'

# Cadre englobant du dessin dans l'image source, mesuré par écart au fond bleu.
CONTENT_BOX = (73, 69, 591, 565)
MARGIN = 1.12
# Décalage vertical du recadrage, en pixels source (positif = grenouille plus haute).
RAISE = 25


def main():
    src = Image.open(SOURCE).convert('RGB')
    x0, y0, x1, y1 = CONTENT_BOX
    side = int(max(x1 - x0, y1 - y0) * MARGIN)
    cx, cy = (x0 + x1) // 2, (y0 + y1) // 2 + RAISE
    crop = src.crop((cx - side // 2, cy - side // 2, cx + side // 2, cy + side // 2))
    big = crop.resize((SIZE, SIZE), Image.LANCZOS)

    big.save(f'{OUT}/icone.png')
    big.convert('RGBA').save(f'{OUT}/icone_foreground.png')

    a = np.asarray(big).astype(float)
    top, bottom = a[:8].mean(axis=(0, 1)), a[-8:].mean(axis=(0, 1))
    ramp = np.linspace(0, 1, SIZE)[:, None, None]
    gradient = (top + (bottom - top) * ramp).repeat(SIZE, axis=1)
    Image.fromarray(gradient.round().astype('uint8')).save(f'{OUT}/icone_background.png')

    print(f'recadrage {side}x{side} centré en ({cx}, {cy})')


if __name__ == '__main__':
    main()
