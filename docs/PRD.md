# PRD — Funty
## Application éducative pour enfants (3-12 ans)

**Version** : 0.33 (QCM Addition bornées 5-8 propositions ; bug retour système en vue enfant corrigé)
**Date** : 2026-07-25
**Statut** : En discussion

---

## 1. Résumé exécutif

Funty est une application éducative destinée aux enfants de 3 à 12 ans, centrée sur deux domaines d'apprentissage : les **mathématiques** et la **lecture/langage**. L'application permet plusieurs **profils utilisateurs sur un même appareil** (typique d'une fratrie) : pour chaque profil, le parent choisit dans une **bibliothèque d'exercices** (organisée par matière puis par thème) lesquels sont disponibles, et l'application enregistre les performances individuellement par profil. Elle fonctionne **hors-ligne**, en français au lancement, et cible **Android uniquement** pour le MVP — **Windows et iOS sont reportés** à une phase ultérieure, pour garder un périmètre technique simple et resserré au lancement.

Le MVP n'intègre **aucune monétisation** : l'objectif premier est de valider le concept pédagogique et l'engagement des enfants avant d'envisager un modèle économique.

---

## 2. Problème et opportunité

Les parents cherchent des applications éducatives qui :
- occupent les enfants de manière constructive plutôt que passive ;
- s'adaptent à l'âge et au niveau réel de l'enfant (une app pour un enfant de 4 ans n'a rien à voir avec une app pour un enfant de 11 ans) ;
- fonctionnent sans connexion internet permanente (trajets, école, zones sans réseau) ;
- ne les inquiètent pas sur la confidentialité des données de leur enfant.

**Hypothèse de valeur** : une seule application, avec une bibliothèque d'exercices que le parent configure lui-même pour chaque enfant, peut couvrir toute la fratrie d'une famille (des profils indépendants sur le même appareil) plutôt que de multiplier les apps mono-usage — sans imposer un découpage par âge rigide que le parent ne contrôle pas.

---

## 3. Public cible

### 3.1 Utilisateurs directs : les enfants
L'application ne repose **pas** sur des profils d'âge prédéfinis. Chaque enfant utilisateur de l'appareil a son propre **profil local** (nom/pseudo, avatar). Ce qui différencie l'expérience d'un profil à l'autre, ce n'est pas une tranche d'âge assignée automatiquement, mais **la sélection d'exercices que le parent a activée pour ce profil précis**.

Deux enfants du même âge peuvent donc avoir des contenus différents, et un enfant peut avoir un mélange d'exercices de niveaux différents si le parent le juge pertinent (enfant en avance sur un domaine, en retrait sur un autre, etc.).

### 3.2 Utilisateurs indirects : les parents
- Créent et gèrent les profils enfants sur l'appareil (plusieurs profils possibles, pour la fratrie).
- Pour chaque profil, parcourent la **bibliothèque d'exercices** (organisée par matière puis par thème) et choisissent lesquels sont disponibles pour cet enfant.
- Consultent les performances enregistrées par profil (par exercice, par thème, par matière).
- S'appuient sur la **classe scolaire recommandée** (PS, MS, GS, CP, CE1, CE2, CM1, CM2) affichée sur chaque exercice comme simple repère de sélection — une indication, pas une restriction technique.

---

## 4. Objectifs du MVP

Puisqu'il n'y a pas de monétisation au lancement, les objectifs sont centrés sur l'**engagement** et l'**apprentissage**, pas le revenu.

| Objectif | Indicateur (KPI) |
|---|---|
| Engagement | Taux de rétention à J7 et J30 par profil enfant |
| Valeur pédagogique perçue | Nombre moyen de sessions/semaine, durée moyenne de session vs. durée cible |
| Adoption de la curation continue par le parent | Fréquence à laquelle le parent ajoute/retire des exercices d'un profil après la création initiale (une curation active et régulière est le comportement attendu, pas une configuration figée une fois pour toutes) |
| Pertinence des exercices choisis | Taux de complétion/réussite par exercice et par profil (un taux très bas ou très haut est un signal que la sélection du parent est peut-être mal calibrée) |
| Confiance parentale | Taux de création d'un 2e profil enfant (signal que le parent fait confiance à l'app) |

---

## 5. Périmètre du MVP

### Inclus dans le MVP
- Écran de gestion des profils enfants sur l'appareil (créer/modifier/supprimer, nom, avatar).
- Bibliothèque d'exercices organisée en **Matière → Thème → Exercice**, couvrant les matières **Mathématiques** et **Lecture/Langage**, chaque exercice portant une **classe scolaire recommandée** (PS, MS, GS, CP, CE1, CE2, CM1, CM2) indicative.
- Écran de curation parental : pour chaque profil, activer/désactiver les exercices disponibles, avec filtres par matière, thème et classe scolaire recommandée.
- Côté enfant : accès uniquement aux exercices activés pour son profil, regroupés par matière puis par thème.
- Enregistrement des performances par profil (par exercice, agrégé par thème et par matière).
- Système de récompenses simple (étoiles, badges) commun aux deux matières.
- Mode hors-ligne complet pour tout le contenu déjà téléchargé.
- Espace parental : gestion des profils, curation des exercices, tableau de bord de performance, protégé par un **code PIN**.
- Application disponible sur **Android uniquement** pour le MVP (Windows et iOS reportés à une phase ultérieure).
- Contenu en **français uniquement** pour le MVP.
- Aucune publicité, aucun achat intégré.

### 5.1 Premiers exercices du MVP

Liste de départ concrète pour amorcer la bibliothèque :

| Matière | Thème | Exercice | Mode de réponse | Classe scolaire |
|---|---|---|---|---|
| Lecture/Langage | Alphabet | Affichage d'une lettre majuscule **droite, police et taille standard**, l'enfant la prononce, l'app vérifie via reconnaissance vocale | Vocal | PS |
| Lecture/Langage | Alphabet | Même exercice que ci-dessus, mais la lettre majuscule est affichée avec **orientation (max 45°), police et taille aléatoires** (variante plus difficile) | Vocal | PS |
| Lecture/Langage | Alphabet | Affichage d'une lettre **minuscule** droite, police et taille standard, l'enfant la prononce, l'app vérifie via reconnaissance vocale | Vocal | MS |
| Lecture/Langage | Alphabet | Même exercice que ci-dessus, mais la lettre minuscule est affichée avec **orientation (max 45°), police et taille aléatoires** (variante plus difficile) | Vocal | MS |
| Mathématiques | Nombres | Affichage d'un chiffre (0 à 9), l'enfant le prononce, l'app vérifie via reconnaissance vocale | Vocal | PS |
| Mathématiques | Addition | Addition de 2 nombres ≤ 5 | Vocal + Tactile | GS |
| Mathématiques | Addition | Addition de 2 nombres ≤ 10 | Vocal + Tactile | GS |
| Mathématiques | Addition | Addition de 2 nombres ≤ 20 (3ᵉ palier, au-delà de ≤5/≤10) | Vocal + Tactile | CP |
| Mathématiques | Soustraction | Soustraction de 2 nombres ≤ 10, le second toujours inférieur au premier (pas de résultat négatif) | Vocal + Tactile | GS |
| Mathématiques | Formes et grandeurs | Affichage d'une forme géométrique (ex. cercle, carré, triangle), l'enfant la nomme, l'app vérifie via reconnaissance vocale | Vocal | PS |
| Mathématiques | Comptage | Compter à voix haute de 1 à 10 : l'enfant dit les chiffres **un par un**, chacun reconnu isolément (même mécanique que l'exercice "Nombres" ci-dessus) ; en cas d'erreur, la bonne réponse est donnée à l'audio et l'exercice reprend depuis le début. **Maximum 5 tentatives par séance**, et **arrêt automatique dès que l'enfant atteint 10** (pas besoin d'épuiser les 5 tentatives). **Exercice sans questions aléatoires** : la sélection adaptative (6.5), les séries/paliers de récompense par vitesse (6.7) et la règle générale des 2 échecs (6.2) ne s'appliquent pas ici — Comptage garde sa seule règle propre décrite ci-dessus. **Score propre 1-3** selon le **meilleur point atteint sur l'ensemble de la séance** (1 = a atteint au moins 5, 2 = au moins 8, 3 = a atteint 10 ; 0 si moins de 5 sur les 5 tentatives) — cf. 6.7. | Vocal | PS |
| Mathématiques | Dénombrement | Un nombre d'objets d'un même type (ex. des chats, des tractopelles — un type d'objet différent à chaque itération) est affiché à l'écran, disposé aléatoirement (position, orientation, taille) sans chevauchement ; l'enfant compte et dit le total à voix haute, l'app vérifie via reconnaissance vocale. **Variante 1 à 5 objets.** | Vocal | PS |
| Mathématiques | Dénombrement | Même exercice que ci-dessus. **Variante 1 à 10 objets**, pour aller plus loin une fois la variante 1 à 5 maîtrisée. | Vocal | PS |

Ces exercices confirment que la **reconnaissance vocale est requise dès le MVP** (cf. décision en 8.1), et reposent tous sur le même principe de reconnaissance de **mot isolé** (une lettre, un chiffre — dit un par un même pour l'exercice Comptage —, le nom d'une forme, ou le résultat d'une addition), ce qui est beaucoup plus simple à obtenir de façon fiable qu'une reconnaissance de phrase ou de séquence — y compris hors-ligne. L'exercice Comptage peut donc réutiliser directement le même composant de reconnaissance que l'exercice "Nombres" (reconnaître un chiffre isolé), simplement enchaîné chiffre après chiffre avec un mécanisme de correction/reprise en cas d'erreur. L'exercice **Dénombrement** répond lui aussi à ce principe : la réponse attendue reste un chiffre isolé (le total compté), la même brique de reconnaissance que "Nombres" et "Comptage" peut donc être réutilisée.

Pour les deux additions, l'enfant pourra donc soit dire le résultat à voix haute, soit le saisir au tactile (QCM, glisser-déposer ou saisie numérique) — l'app acceptant l'une ou l'autre réponse indifféremment.

**Variantes de présentation pour l'Alphabet (majuscules et minuscules)** :
- Le thème Alphabet passe de 1 à 4 exercices : majuscules (présentation standard), majuscules (orientation/police/taille aléatoires), minuscules (présentation standard), minuscules (orientation/police/taille aléatoires). Les 2 variantes "aléatoires" réutilisent exactement la même reconnaissance vocale que les versions standard (cf. plus haut) — seule la présentation visuelle change, pas la mécanique de réponse.
- **Amplitude de rotation confirmée** : rotation libre pour la plupart des lettres ; **limitée à 45° maximum uniquement pour les lettres à risque de confusion par rotation** ("b"/"d"/"p"/"q", "M"/"W") — cf. risque résiduel en section 10.
- **Pool de polices confirmé : 3 polices courantes** — **Roboto** (police système par défaut d'Android), **Verdana** (très lisible à l'écran, formes de lettres bien distinctes) et **Comic Sans MS** (ou son équivalent libre **Comic Neue** pour éviter tout souci de licence) — un choix volontairement courant et reconnaissable plutôt que des polices spécialisées "littératie" moins familières. À valider visuellement au cas par cas sur les lettres à risque avant production (cf. 11).
- Ce principe de "variante de présentation visuelle" (orientation/police/taille aléatoires) pourrait aussi s'appliquer à d'autres exercices de reconnaissance à l'avenir (chiffres, formes) dans la logique de croissance continue de la bibliothèque (cf. 8.1), sans que ce soit acté pour le MVP au-delà de l'Alphabet.

**Particularités de l'exercice Dénombrement** :
- **Deux variantes par quantité, confirmées** : "1 à 5" et "1 à 10", comme deux exercices distincts dans le catalogue (sur le même principe que les deux variantes de l'exercice Addition) — le parent peut activer l'une, l'autre, ou les deux pour un profil donné.
- **Banque d'objets par catégorie** : contrairement aux autres exercices qui portent sur un contenu fixe (26 lettres, 10 chiffres, quelques formes), Dénombrement nécessite une **banque d'illustrations par catégorie d'objet** (chats, tractopelles, etc.) tirée aléatoirement à chaque itération, partagée par les deux variantes — un besoin de contenu (assets visuels) à budgétiser séparément de la logique de l'exercice, et qui s'inscrit dans la logique de croissance continue de la bibliothèque (cf. 8.1) : on pourra ajouter des catégories d'objets au fil du temps sans toucher au code de l'exercice.
- **Disposition aléatoire sans chevauchement** : position, orientation et taille aléatoires pour chaque objet, avec une contrainte de non-chevauchement à faire respecter par un algorithme de placement (avec nouvelle tentative si une position choisie chevauche un objet déjà placé) — un développement à part entière, distinct de la reconnaissance vocale (cf. risque en section 10), à concevoir pour supporter les deux variantes (jusqu'à 10 objets pour la seconde).

### Explicitement hors périmètre MVP (à réévaluer plus tard)
- Monétisation (abonnement, achats intégrés, publicité).
- Compte cloud / synchronisation multi-appareils.
- Contenu généré ou adapté dynamiquement par IA.
- Réseau social entre enfants, chat, partage public.
- Recommandations automatiques d'exercices basées sur la performance (le parent reste seul décisionnaire au MVP).
- Domaines pédagogiques additionnels (sciences, langues étrangères, etc.).
- Messages de fin d'exercice tenant compte du progrès par rapport à l'historique des tentatives précédentes (au MVP, les messages sont génériques et dépendent uniquement du score obtenu — cf. 6.7).

---

## 6. Exigences fonctionnelles détaillées

### 6.1 Gestion des profils (multi-utilisateurs, même appareil)
- Tous les profils vivent **localement sur l'appareil** (pas de compte cloud requis au MVP).
- Un ou plusieurs profils enfants créés directement sur l'appareil, sans limite fonctionnelle particulière au MVP.
- Chaque profil enfant a : prénom/pseudo, avatar, et sa **propre sélection d'exercices actifs** (cf. 6.3) et son **propre historique de performances** (cf. 6.4).
- **Pas de réglage son on/off** : le son et les animations font partie intégrante des récompenses motivant l'enfant (cf. 6.7), ce ne sont pas des options à désactiver.
- Aucune tranche d'âge n'est attachée au profil lui-même : l'âge n'intervient qu'en métadonnée sur les exercices (cf. 6.2).
- Changement de profil protégé par une action simple mais non triviale pour un jeune enfant (ex. maintien de 3 secondes ou petit calcul), pour éviter les changements accidentels.
- Accès à l'espace de curation/paramétrage (6.6) protégé séparément par le code PIN parental.

### 6.2 Bibliothèque d'exercices (catalogue)
- Structure à deux niveaux : **Matière** (ex. Mathématiques, Lecture/Langage) → **Thème** (ex. "Addition", "Formes et grandeurs", "Alphabet", "Syllabes") → **Exercices** individuels.
- Chaque exercice porte des métadonnées : matière, thème, **classe scolaire recommandée** (une valeur parmi PS, MS, GS, CP, CE1, CE2, CM1, CM2 — système scolaire français), **mode de réponse** (vocal / tactile / vocal + tactile — attribut propre à chaque exercice, indépendant de la matière ou du thème), et si le mode inclut le tactile, un format d'interaction précis (QCM, glisser-déposer, tracé, dénombrement...), plus un niveau de difficulté.
- Le mode de réponse n'est donc pas figé par matière (ex. la Lecture/Langage n'est pas "toujours vocale", les Mathématiques ne sont pas "toujours tactiles") : il se décide exercice par exercice selon ce qui est le plus adapté.
- Pour un exercice en mode **vocal + tactile**, l'enfant choisit librement comment répondre (dire la réponse à voix haute, ou la saisir/sélectionner au tactile) ; l'app doit accepter les deux sans imposer un choix préalable — détail d'interaction à préciser en phase de maquettage (cf. 11).
- La classe scolaire recommandée est **indicative uniquement** : elle sert de filtre de recherche pour le parent, elle ne bloque techniquement l'accès à aucun exercice.
- La bibliothèque est commune à tous les profils de l'appareil ; ce qui varie par profil, c'est l'activation (cf. 6.3), pas le contenu lui-même.
- **Feedback immédiat (visuel + sonore) confirmé, sur chaque tentative** : un bref flash plein écran (vert = bonne réponse, rouge = mauvaise) accompagné d'un son court et distinct, déclenché à chaque tentative de réponse — y compris une réponse fausse rapide par ailleurs ignorée par le calcul de sélection adaptative (cf. 6.5), pour que le retour perceptif reste immédiat indépendamment de ce qui compte pour le score. Cohérent sur tous les exercices, y compris Comptage.
- **Propositions QCM confirmées : 5 à 8 réponses groupées autour de la bonne valeur, jamais au-delà du plafond de l'exercice.** Pour les exercices Addition (≤5/≤10/≤20), aucune proposition ne doit dépasser le plafond de l'exercice (ex. jamais de "6" proposé sur Addition ≤5) — les valeurs voisines de la bonne réponse sont piochées des deux côtés jusqu'à réunir 5 à 8 propositions, en respectant cette borne (et 0 en borne basse). Peut donner moins de 5 propositions si peu de valeurs valides existent à proximité (ex. bonne réponse = plafond de l'exercice).
- **Paramètres de récompense par exercice** : le **nombre de questions par série** et les **seuils de temps bronze/argent/or** (cf. 6.7) sont des réglages propres à chaque exercice (une addition peut avoir des seuils différents d'une lettre isolée), **pas propres à un profil** — le parent les ajuste une fois par exercice, et ce réglage s'applique alors à tous les profils de l'appareil qui pratiquent cet exercice. Une valeur par défaut raisonnable est proposée par exercice, ajustable ensuite dans l'espace parental (cf. 6.6).
- **Révélation de la réponse après 2 échecs, avec pénalité de temps** : sur la plupart des exercices, si l'enfant se trompe 2 fois de suite sur la même question, l'application donne la bonne réponse (à l'oral, cohérent avec la consigne orale systématique) avant de passer à la question suivante — pas de blocage indéfini sur une question. Cet événement ajoute une **pénalité de 5 secondes** au temps de réponse enregistré pour cette question (cf. 6.5), pour que la difficulté se reflète dans le suivi même si le temps "brut" ne compte que jusqu'à la bonne réponse.
- **Consigne orale systématique** : chaque exercice, quel que soit son mode de réponse, explique sa tâche à l'enfant **à l'oral** (ex. "Compte les chats et dis le nombre à voix haute"), et pas seulement par texte ou pictogramme — indispensable pour les enfants qui ne savent pas encore lire (PS notamment). C'est une métadonnée/asset obligatoire de chaque exercice, pas une option.
- **Granularité "question"** : pour la plupart des exercices, le contenu se décompose en **questions/items individuels** au sein d'un même exercice (ex. les 26 lettres de l'exercice Alphabet, les paires possibles de l'exercice Addition ≤5, les types d'objets de Dénombrement). C'est à ce niveau, plus fin que l'exercice, que porte le suivi des performances et la sélection adaptative (cf. 6.5). **L'exercice Comptage n'entre pas dans ce modèle** : ce n'est pas un enchaînement de questions aléatoires indépendantes mais une tâche continue (réciter 1 à 10), donc ni la granularité "question", ni la sélection adaptative, ni les paramètres de récompense par série (cf. 6.7) ne s'y appliquent — cf. 5.1 pour sa règle propre.

### 6.3 Sélection des exercices par profil (curation parentale)
- **À la création d'un profil**, aucune sélection par défaut : l'interface affiche directement le catalogue (filtrable par matière, thème, classe scolaire recommandée) et le parent choisit lui-même les exercices à ajouter pour démarrer. Pas d'écran de configuration "magique" à concevoir, juste le catalogue.
- **Curation continue, pas une configuration ponctuelle** : le parent est censé revenir régulièrement ajouter de nouveaux exercices et en retirer d'anciens au fur et à mesure des progrès de l'enfant. À un instant donné, un profil n'a donc généralement qu'un **nombre volontairement réduit d'exercices actifs** — ce n'est pas un signe d'usage incomplet, c'est le fonctionnement normal prévu de l'app.
- Cette logique doit se refléter dans l'interface parentale : il doit être aussi simple de **retirer** un exercice devenu trop facile que d'en **ajouter** un nouveau (actions symétriques, accessibles rapidement, pas seulement l'ajout mis en avant).
- Un même exercice peut être activé pour plusieurs profils simultanément (le contenu est partagé ; l'activation est propre à chaque profil).
- Côté enfant, l'application n'affiche que les exercices activés pour son profil, regroupés par matière puis par thème — aucune notion de niveau/palier imposé par l'app elle-même.

### 6.4 Suivi des performances
- Par profil, enregistrement pour chaque exercice pratiqué : score/réussite, nombre de tentatives, temps passé, date de dernière pratique.
- Pour les exercices concernés (cf. granularité "question" en 6.2), ce suivi descend au niveau de la **question précise** : temps de réponse et résultat (juste/faux) de chaque tentative sur cette question — pas seulement un score global par exercice.
- Agrégation de ces données par thème et par matière pour donner une vue d'ensemble par profil (ex. "80% de réussite sur le thème Addition").
- Ces données alimentent le tableau de bord parental (6.6) et le mécanisme de sélection adaptative (6.5) ; l'enfant voit une version simplifiée et positive de sa progression (récompenses, cf. 6.7), pas le détail analytique.

### 6.5 Sélection adaptative des questions
- **Principe** : pour la plupart des exercices composés de plusieurs questions (ex. les lettres de l'Alphabet, les paires d'Addition, les objets de Dénombrement), l'application analyse le **temps de réponse** de l'enfant sur chaque question et repose plus fréquemment celles pour lesquelles ce temps est plus long.
- **Définition du temps de réponse : uniquement le temps jusqu'à la bonne réponse, plus pénalité éventuelle.** Une réponse fausse donnée rapidement est **simplement ignorée** : elle n'est ni comptabilisée comme un temps court, ni comme une tentative à part entière — l'enfant continue d'essayer, et seul le temps écoulé jusqu'à la réponse correcte est enregistré. **Exception** : si l'enfant enchaîne 2 échecs consécutifs sur la même question (cf. 6.2), une pénalité fixe de **5 secondes** est ajoutée au temps enregistré pour cette question, en plus de la révélation de la bonne réponse par l'app.
- **Calcul** : la fréquence de sélection d'une question se base sur la **moyenne des temps de réponse (jusqu'à la bonne réponse, pénalités incluses) des 3 dernières tentatives** sur cette question précise (pas sur l'historique complet).
- **Amorçage d'une question jamais vue** : tant qu'il reste, dans un exercice, des questions que le profil n'a jamais pratiquées, elles sont **prioritaires** sur les questions déjà vues (peu importe leur temps moyen) — mais le choix **parmi** les questions jamais vues reste **aléatoire**, pas dans un ordre fixe.
- **Contrainte d'enchaînement** : la même question n'est **jamais posée deux fois de suite**, même si elle est prioritaire selon le calcul ci-dessus.
- **Alimente les statistiques parentales** (cf. 6.6) : ce même suivi par question permet au parent de voir précisément quelles questions posent difficulté à l'enfant (ex. "la lettre Y", "l'addition 7+8"), au-delà des taux agrégés par exercice/thème/matière (cf. 6.4).
- **Ne s'applique pas à l'exercice Comptage**, qui n'est pas composé de questions aléatoires indépendantes (cf. 6.2 et 5.1).

### 6.6 Espace parental
- Accès protégé par un **code PIN** pour empêcher l'enfant d'y entrer seul.
- Gestion des profils : créer/modifier/supprimer un profil enfant.
- Curation des exercices par profil (cf. 6.3).
- Tableau de bord de performance par profil : temps passé, exercices/thèmes pratiqués, taux de réussite (cf. 6.4).
- **Statistiques par question** : le parent peut consulter les questions précises qui posent le plus de difficulté à l'enfant au sein d'un exercice (ex. "l'enfant a plus de mal avec la lettre Y" ou "avec l'addition 7+8"), sur la base du suivi par question (cf. 6.4 et 6.5).
- **Niveau de récompense par exercice** (cf. 6.7) : visible dans le tableau de bord comme indicateur simple et lisible de la maîtrise de l'enfant sur chaque exercice, en complément des statistiques plus détaillées.
- **Réglage du nombre de questions par série (via un slider, défaut 10) et des seuils bronze/argent/or par exercice** (cf. 6.7) : ce réglage s'applique à tous les profils de l'appareil pratiquant cet exercice, pas seulement au profil consulté.
- Réglages additionnels : définir un temps de session recommandé (rappel doux, pas de blocage strict au MVP).

### 6.7 Système de récompenses et progression
- Le son et les animations sont eux-mêmes des **récompenses** pour l'enfant (cf. 6.1) : ils ne sont ni configurables ni désactivables au MVP.
- **Thème visuel unique et fixe : les "Grenouilles à lunettes".** Après réflexion, un système d'univers personnalisables par profil a été jugé trop complexe pour la valeur ajoutée qu'il apporte à un MVP — remplacé par un seul thème de récompense, commun à tous les profils, pas de choix ni de configuration à ce niveau.
- **Stockage du niveau de badge : une valeur numérique 0 à 3.** Par exercice et par profil, l'app conserve un simple niveau (0 = aucun badge, 1 = bronze, 2 = argent, 3 = or), représenté visuellement par une grenouille à lunettes bronze/argent/or.
- **Récompenses de vitesse par exercice** : les exercices à questions multiples se déroulent par séries ; à l'issue d'une série, l'enfant obtient un badge "Grenouille à lunettes" selon le **temps moyen par question** sur la série (moyenne du temps jusqu'à la bonne réponse sur toutes les questions de la série, cf. 6.5) :
  - 🥉 **Bronze** (niveau 1), 🥈 **Argent** (niveau 2), 🥇 **Or** (niveau 3) — trois paliers de temps moyen par question, croissants en exigence.
- **Valeurs par défaut confirmées** : **10 questions par série**, avec un temps moyen par question de **≤ 7 s pour bronze**, **≤ 4 s pour argent**, **≤ 2 s pour or**. Utiliser une moyenne par question plutôt qu'un temps total permet de garder les mêmes seuils cohérents même si le nombre de questions est modifié.
- **Nombre de questions par série et seuils de temps : propres à chaque exercice, pas à un profil.** Ce ne sont pas des valeurs uniques imposées à toute la bibliothèque (une addition n'a pas forcément le même rythme qu'une lettre isolée) : chaque exercice démarre avec les valeurs par défaut ci-dessus, ajustables par le parent dans l'espace parental (cf. 6.6) — le réglage vaut alors pour tous les profils de l'appareil pratiquant cet exercice. Le **nombre de questions** se règle via un **slider** dans l'interface parentale.
- Ce badge est calculé **par exercice et par profil** ; seul le meilleur niveau obtenu (or > argent > bronze) est conservé comme reflet de la maîtrise de l'enfant sur cet exercice, visible à la fois par l'enfant (motivation) et par le parent (cf. 6.6, où en est l'enfant dans son apprentissage).
- **Ne s'applique pas à l'exercice Comptage** : n'étant pas composé de questions aléatoires en série (cf. 6.2 et 5.1), il n'a pas de badge basé sur un temps de série — il a cependant son **propre score 1-3**, basé sur le nombre atteint plutôt que sur un temps (cf. ci-dessous), et conserve ses récompenses génériques (étoiles, badges de série ci-dessous).
- Badges de complétion de thème ou de série (ex. "5 jours d'affilée"), également dans le thème des grenouilles à lunettes.
- Vue de progression simple et visuelle pour l'enfant (ex. carte de parcours par thème), séparée du détail analytique réservé aux parents.
- **Message de fin d'exercice, personnalisé et toujours positif — simplifié pour le MVP** : à la fin de chaque série (ou de chaque tentative pour Comptage), l'enfant reçoit un message oral (cohérent avec la consigne orale systématique, cf. 6.2), **jamais négatif ou critique**, même en cas de difficulté. **Pour le MVP, ce message est générique et dépend uniquement du score obtenu** (le niveau 0-3 de la série, cf. ci-dessus) — pas de comparaison à l'historique des tentatives précédentes ni de détection explicite de "progrès" (fonctionnalité reportée après le MVP, cf. 5) :
  - Score = **or** (3) : message très enthousiaste (ex. "Bravo, tu as été super rapide sur ce coup-là, tu as gagné une grenouille dorée !").
  - Score = **argent** (2) ou **bronze** (1) : message positif de félicitations, adapté au palier.
  - Score = **0** (aucun badge) : message d'encouragement bienveillant, jamais critique (ex. "Aïe aïe aïe, c'était difficile on dirait. Ce n'est pas grave, avec un peu d'entraînement je suis sûr que tu arriveras à mieux faire la prochaine fois").
- **Trois variantes par score pour le MVP** : pour chacun des 4 niveaux de score (0/bronze/argent/or), au moins 3 phrases différentes tirées aléatoirement, pour limiter la répétition mot pour mot sans multiplier le travail d'écriture.
- **Score de Comptage confirmé, basé sur le meilleur point atteint (pas sur un temps)** : sur une séance d'**au maximum 5 tentatives**, l'application retient le **meilleur point jamais atteint**, même après un ou plusieurs redémarrages suite à une erreur (cf. 5.1) : 1 = au moins 5 atteint, 2 = au moins 8 atteint, 3 = 10 atteint (complet), 0 = moins de 5 sur les 5 tentatives. La séance s'arrête automatiquement dès que l'enfant atteint 10, sans attendre d'épuiser les 5 tentatives. Ce score sert de base au message de fin d'exercice, sur le même principe que les autres exercices (3 variantes par score).
- **Banque de messages pré-écrits, pas de génération dynamique** : cohérent avec l'exclusion du contenu généré par IA au MVP (cf. 5), ces messages proviennent d'une bibliothèque de phrases pré-écrites (probablement pré-enregistrées à la voix humaine, comme les autres consignes orales), organisées uniquement par score pour le MVP.

### 6.8 Fonctionnement hors-ligne
- Tout le contenu pédagogique (textes, images, audio, logique d'exercices) est embarqué dans l'application ou téléchargé une fois puis disponible sans réseau.
- Les profils, la sélection d'exercices par profil et les performances sont stockés localement sur l'appareil.
- Aucune fonctionnalité du MVP ne doit *requérir* une connexion internet active.

---

## 7. Exigences non fonctionnelles

| Catégorie | Exigence |
|---|---|
| **Plateformes** | **Android uniquement** pour le MVP ; **Windows et iOS reportés** à une phase ultérieure. **Flutter** reste recommandé même en mono-plateforme : il facilitera l'ajout de Windows (cible desktop native) et d'iOS plus tard sans réécriture. Framework à valider en phase technique. |
| **Adaptation d'entrée** | Interface pensée uniquement pour le **tactile** au MVP (pas de contrainte clavier/souris) ; distribution via le **Google Play Store** uniquement. L'adaptation clavier/souris et les pipelines de build/distribution additionnels ne seront à traiter que lorsque Windows sera ajouté. |
| **Performance** | Démarrage de l'app < 3 secondes sur un appareil d'entrée de gamme ; animations fluides (60 fps cible) pour maintenir l'attention des jeunes enfants |
| **Accessibilité** | Contrastes suffisants, cibles tactiles larges (adaptées à des petits doigts), audio activable/désactivable, support possible de la synthèse vocale du système |
| **Confidentialité / protection des mineurs** | Conformité RGPD (application dans un contexte francophone/européen) ; collecte de données minimale ; pas de publicité ciblée ; pas de partage de données à des tiers ; à examiner : équivalent COPPA si diffusion hors UE |
| **Sécurité** | Aucune donnée sensible transmise en clair ; stockage local chiffré si des informations identifiantes sont conservées |
| **Robustesse hors-ligne** | Aucune perte de progression en cas de fermeture brutale de l'app ou d'absence de réseau |

---

## 8. Décisions et points encore à trancher

### 8.1 Décisions actées (2026-07-24)
- **Android uniquement pour le MVP (revirement)** : après examen, le support Windows dès le MVP compliquait sensiblement le projet (double toolchain, double surface de test, adaptation clavier/souris, reconnaissance vocale à valider sur deux moteurs différents) — l'inverse de l'objectif initial, qui était de se simplifier la vie en testant localement sur un plus grand écran. **Windows et iOS sont donc tous deux reportés** à une phase ultérieure. Le besoin de confort de test sur grand écran reste satisfiable pendant le développement via un émulateur Android en grande résolution ou une tablette Android, sans avoir à maintenir une cible Windows en production.
- **Langue : français uniquement pour le MVP.** Le multilingue n'est pas exclu plus tard mais n'est pas un objectif MVP.
- **Verrou parental : par code PIN**, pour protéger à la fois la configuration des exercices (curation) et l'accès aux statistiques de performance (cf. 6.6).
- **Nom du produit confirmé : Funty.**
- **Alignement pédagogique souple** : les classes scolaires (PS→CM2) et le contenu des exercices s'inspirent des programmes de l'Éducation nationale sans viser une conformité stricte/validée au lancement. À revisiter si l'app cherche plus tard une crédibilité renforcée auprès d'enseignants (ex. V2).
- **Reconnaissance vocale confirmée pour le MVP** : neuf des douze exercices (4 exercices Alphabet, chiffres 0-9, formes géométriques, comptage jusqu'à 10, dénombrement 1-5, dénombrement 1-10) sont purement vocaux, et 3 autres (Addition ×2, Soustraction) sont vocal + tactile — cf. section 5.1. Portée limitée à la reconnaissance d'un **mot isolé à chaque fois** (un chiffre, une lettre, un nom de forme), y compris pour Comptage et Dénombrement où la réponse reste un seul chiffre (pas de reconnaissance de séquence ni de phrase libre).
- **Mécanique de correction du Comptage** : en cas d'erreur sur un chiffre, l'app donne la bonne réponse à l'oral et l'exercice **reprend depuis le début** (retour à 1), plutôt que de simplement continuer après correction.
- **Mode de réponse = attribut par exercice, pas par matière** : chaque exercice est vocal, tactile, ou les deux, selon ce qui convient le mieux — ce n'est jamais une règle fixe liée à la matière ou au thème (cf. 6.2).
- **Premiers exercices, classes scolaires et modes de réponse confirmés** : reconnaissance orale des lettres majuscules (PS, vocal), reconnaissance orale des chiffres 0-9 (PS, vocal), addition de 2 nombres ≤5 (GS, vocal + tactile), addition de 2 nombres ≤10 (GS, vocal + tactile), reconnaissance des formes géométriques (PS, vocal), comptage à voix haute de 1 à 10 (PS, vocal), dénombrement 1 à 5 objets (PS, vocal), dénombrement 1 à 10 objets (PS, vocal) — cf. section 5.1.
- **Croissance continue de la bibliothèque actée comme stratégie de fond** : Funty a vocation à accueillir "plein d'autres exercices par la suite" — l'architecture (catalogue Matière → Thème → Exercice, curation par profil) doit donc rester facile à enrichir en continu après le lancement, pas seulement pendant la conception du MVP.
- **Pas de sélection par défaut à la création d'un profil** : l'interface affiche directement le catalogue, sans suggestion automatique ; le parent choisit lui-même dès le départ (cf. 6.3).
- **Curation continue plutôt que configuration ponctuelle** : le parent ajoute/retire des exercices au fil des progrès de l'enfant, si bien qu'un profil n'a en pratique qu'un **petit nombre d'exercices actifs à la fois** — c'est le fonctionnement normal visé, pas un défaut à corriger (cf. 6.3). Cela relativise la question de la "taille de la bibliothèque au lancement" : ce qui compte n'est pas le nombre total d'exercices disponibles au jour 1, mais la facilité à ajouter/retirer rapidement au fil du temps.
- **Classe scolaire de l'exercice "Formes et grandeurs" confirmée : PS.**
- **Dénombrement scindé en 2 exercices (7ᵉ et 8ᵉ) : "1 à 5" et "1 à 10" (PS, vocal)** : compter un nombre d'objets d'un type donné (différent à chaque itération, ex. chats, tractopelles), disposés aléatoirement à l'écran (position, orientation, taille) sans chevauchement, et dire le total à voix haute — cf. section 5.1 pour le détail.
- **Taille du catalogue au lancement du MVP confirmée suffisante** : les 8 exercices déjà définis suffisent pour le lancement ; d'éventuels exercices supplémentaires seront proposés au fil de l'eau, sans engagement sur un nombre précis à date. *(Mise à jour : conformément à cette logique, 4 exercices supplémentaires ont depuis été ajoutés — cf. plus bas —, portant le total à 12.)*
- **Toutes les consignes d'exercice sont données à l'oral**, quel que soit le mode de réponse de l'exercice (vocal, tactile, ou les deux) — nécessaire pour les enfants PS/MS qui ne savent pas encore lire. Ce n'est pas spécifique à Dénombrement : c'est une exigence transverse à toute la bibliothèque (cf. 6.2).
- **Sélection adaptative des questions actée pour la plupart des exercices** : le temps de réponse est analysé par question (pas seulement par exercice), avec une moyenne glissante sur les 3 dernières tentatives — plus ce temps est long, plus la question revient fréquemment, sans jamais la reposer deux fois de suite (cf. 6.5).
- **Statistiques par question pour le parent** : au-delà des agrégats par exercice/thème/matière, le parent pourra voir les questions précises qui posent difficulté à l'enfant (ex. la lettre "y", l'addition "7+8") — cf. 6.6.
- **Temps de réponse = temps jusqu'à la bonne réponse uniquement** : une réponse fausse donnée rapidement est simplement ignorée, elle n'entre dans aucun calcul (ni sélection adaptative, ni badges) — cf. 6.5.
- **Pas de réglage son on/off au MVP** : le son et les animations sont conçus comme des récompenses motivantes pour l'enfant, pas des options désactivables — ceci supprime aussi la tension précédemment identifiée avec les consignes orales obligatoires (plus de risque de bloquer un enfant non-lecteur en coupant le son).
- **Système de récompenses par vitesse actée** : séries de questions par exercice, avec 3 paliers selon le **temps moyen par question** pour y répondre correctement (bronze/argent/or). Sert à la fois de motivation pour l'enfant et de repère de maîtrise pour le parent — cf. 6.7.
- **Thème de récompense unique et fixe : "Grenouilles à lunettes" (revirement)** : le système d'univers personnalisables par profil (tractopelle, pompier, licorne, etc.) a été jugé trop complexe pour sa valeur ajoutée en MVP et a été abandonné. Un seul thème visuel, commun à tous les profils, représente les 3 paliers (bronze/argent/or) — pas de choix ni de configuration par profil sur ce point. La donnée stockée reste un simple niveau numérique 0-3 par exercice et par profil — cf. 6.1 et 6.7.
- **Nombre de questions par série et seuils de temps : par exercice, pas par profil, et configurables par le parent.** Ce ne sont pas des valeurs fixes universelles imposées sans possibilité d'ajustement : chaque exercice démarre avec les mêmes valeurs par défaut, réglables ensuite par le parent dans l'espace parental, et le réglage s'applique à tous les profils de l'appareil — cf. 6.6 et 6.7.
- **Valeurs par défaut du système de récompense entièrement fixées, dernière question ouverte du document résolue** : **10 questions par série** (ajustable via un slider parental), temps moyen par question ≤ 7 s pour bronze, ≤ 4 s pour argent, ≤ 2 s pour or — cf. 6.7.
- **Révélation de la bonne réponse après 2 échecs** : sur la plupart des exercices, 2 erreurs consécutives sur la même question déclenchent la révélation de la bonne réponse par l'app, avant de passer à la suite — pas de blocage indéfini. Ceci répond et clôt la question précédemment ouverte sur la gestion des échecs répétés.
- **Comptage confirmé comme exception, pas une incohérence à corriger** : ce n'est pas un exercice à questions aléatoires, donc ni la sélection adaptative (6.5), ni les séries/seuils de récompense (6.7), ni la règle des 2 échecs (6.2) ne s'y appliquent. Sa règle propre ("reprend depuis le début" dès la 1ʳᵉ erreur, cf. 5.1) reste telle quelle — ce qui clôt la question de réconciliation précédemment ouverte.
- **Message de fin d'exercice, personnalisé et toujours positif, acté** : à l'oral, félicite le score obtenu (0-3) et reste bienveillant/encourageant même en cas de difficulté (jamais négatif ou critique) — cf. 6.7. **Simplifié pour le MVP** : générique et basé uniquement sur le score, sans comparaison à l'historique (la détection explicite de "progrès" dans le message est reportée après le MVP, cf. 5). Provient d'une banque de phrases pré-écrites, pas d'une génération dynamique (cohérent avec l'exclusion de l'IA générative au MVP, cf. 5) — **3 variantes par score confirmées pour le MVP**.
- **Amorçage des nouvelles questions confirmé** : priorité aux questions jamais vues par le profil sur cet exercice, choisies **aléatoirement** parmi elles tant qu'il en reste — cf. 6.5.
- **Score de Comptage entièrement défini** : basé sur le **meilleur point atteint sur l'ensemble de la séance** (même à travers plusieurs redémarrages après erreur), pas seulement le dernier passage — 1 = au moins 5, 2 = au moins 8, 3 = 10 complet, 0 = moins de 5. **Maximum 5 tentatives par séance**, avec **arrêt automatique dès que l'enfant atteint 10** — cf. 6.7 et 5.1.
- **Pénalité de temps sur 2 échecs consécutifs confirmée** : +5 secondes ajoutées au temps enregistré pour la question lors de la révélation après 2 échecs (cf. 6.2 et 6.5) ; le "progrès" pour la sélection adaptative ne se mesure donc que par le temps (pénalité incluse), sans pondération distincte du taux de réussite.
- **3 nouveaux exercices ajoutés au thème Alphabet (9ᵉ, 10ᵉ et 11ᵉ)** : majuscules en présentation aléatoire (orientation/police/taille), minuscules en présentation standard, minuscules en présentation aléatoire — cf. section 5.1.
- **12ᵉ exercice ajouté : Soustraction de 2 nombres ≤10 (le second toujours inférieur au premier, pas de résultat négatif)**, sur le même principe que l'Addition (vocal + tactile) — cf. section 5.1.
- Le catalogue MVP passe donc de 8 à **12 exercices**.
- **Classes scolaires des nouveaux exercices confirmées** : majuscules variante aléatoire (PS), minuscules standard et variante aléatoire (**MS**), Soustraction (GS) — cf. section 5.1.
- **Amplitude de rotation des variantes Alphabet confirmée** : rotation libre en général, **limitée à 45° max uniquement pour les lettres à risque de confusion** (b/d/p/q, M/W) — cf. section 5.1 et 10.
- **Pool de polices confirmé : 3 polices courantes** — Roboto, Verdana, Comic Sans MS (ou Comic Neue, équivalent libre) — choisies pour leur familiarité plutôt que des polices spécialisées, à valider visuellement sur les lettres à risque avant production — cf. section 5.1 et 11.

### Décisions actées (2026-07-25)

- **Feedback immédiat bonne/mauvaise réponse entièrement défini** : flash plein écran bref (vert/rouge) + son court et distinct, sur chaque tentative de réponse — y compris une réponse fausse rapide par ailleurs ignorée par le calcul de sélection adaptative (cf. 6.5). S'applique à tous les exercices, y compris Comptage — cf. 6.2.
- **13ᵉ exercice ajouté : Addition (résultat ≤ 20)**, 3ᵉ palier de difficulté au-delà de ≤5/≤10, classe scolaire **CP** (au-delà du niveau GS des deux premiers paliers) — cf. section 5.1. Le catalogue MVP passe donc de 12 à **13 exercices**.
- **Vocabulaire vocal 11-20 non encore validé sur appareil** : contrairement au vocabulaire 0-10 et aux lettres (validés via le parcours systématique du spike, cf. section 12), les mots "onze" à "vingt" — notamment les nombres composés "dix-sept"/"dix-huit"/"dix-neuf" — n'ont pas été soumis au même test de reconnaissance réelle. Point à vérifier en priorité si des échecs de reconnaissance apparaissent sur l'exercice Addition ≤ 20, sur le même principe que la résolution des lettres H/M/N/X en son temps.
- **Propositions QCM des exercices Addition bornées et élargies** : 5 à 8 réponses (au lieu de 4), groupées autour de la bonne valeur, jamais au-delà du plafond ≤5/≤10/≤20 de l'exercice — cf. 6.2.
- **Bug corrigé : le geste retour système faisait quitter l'application depuis la vue enfant.** La vue enfant est atteinte par un remplacement de route (`go`, pas d'historique en dessous) : le retour système n'avait donc rien vers quoi revenir et fermait l'app entièrement, plutôt que de ne rien faire. Puisque le PRD 6.1 exige déjà un geste non trivial (maintien de 3 secondes) pour changer de profil, le retour système est maintenant absorbé sans effet sur cet écran — cohérent avec la protection existante plutôt qu'un contournement à une pression.

### 8.2 Points encore ouverts

Aucune question ouverte à ce stade — tous les points soulevés jusqu'ici ont été tranchés (cf. 8.1). De nouvelles questions apparaîtront naturellement à mesure que la conception détaillée avance.

---

## 9. Roadmap proposée

| Phase | Contenu |
|---|---|
| **MVP** | Multi-profils sur l'appareil + bibliothèque en croissance continue (12 exercices actés au lancement, cf. 5.1) + curation parentale complète (code PIN) + suivi des performances + hors-ligne total, sur **Android uniquement** |
| **V1** | **Windows et/ou iOS** (à prioriser le moment venu), bibliothèque élargie (plus de thèmes/exercices par matière), espace parental enrichi (ex. export/partage des performances) |
| **V2** | Monétisation à définir, domaines pédagogiques additionnels, synchronisation multi-appareils, recommandations automatiques d'exercices |

*Recommandation : le MVP n'a plus besoin d'être resserré sur un seul "profil d'âge" puisque ce concept disparaît. En revanche, il reste utile de limiter le nombre de thèmes par matière au lancement pour livrer une bibliothèque cohérente et bien testée plutôt qu'une bibliothèque large mais superficielle.*

---

## 10. Risques et hypothèses

- **Charge de curation continue pour le parent** : le modèle retenu suppose que le parent revient régulièrement ajuster la sélection d'exercices (pas une configuration ponctuelle) ; si l'interface de curation n'est pas assez rapide/fluide, ce geste répété peut devenir une friction et être délaissé avec le temps. À surveiller via le KPI de fréquence de curation (section 4) et à atténuer par de bons filtres et des actions d'ajout/retrait symétriques et rapides (cf. 6.3).
- **Hypothèse non validée** : les parents préfèrent choisir eux-mêmes les exercices plutôt que de suivre un parcours imposé par tranche d'âge (à valider par des retours utilisateurs réels dès que possible).
- **Alignement pédagogique souple (décision actée)** : sans validation stricte des classes scolaires par un enseignant ou un référentiel officiel, un décalage ponctuel entre le niveau affiché et le contenu réel est possible ; risque accepté pour le MVP, à réévaluer si l'app vise une crédibilité renforcée auprès des enseignants.
- **Mono-plateforme au MVP (risque réduit, décision actée)** : en se limitant à Android, le MVP évite le doublement de la surface de test, du toolchain et de l'adaptation d'entrée qu'aurait imposé Windows. Ce risque réapparaîtra mécaniquement quand Windows et/ou iOS seront ajoutés (V1) : à anticiper dans le planning à ce moment-là plutôt que dès maintenant.
- **Faisabilité de la reconnaissance vocale hors-ligne sur Android** : reconnaître un mot isolé (une lettre, un chiffre ou le nom d'une forme) est plus simple qu'une phrase, mais la prononciation d'un jeune enfant (voix, articulation) est plus difficile à reconnaître que celle d'un adulte, même sur un seul moteur de reconnaissance. Le spike technique confirme la faisabilité générale (cf. section 12) mais reste à tester avec une vraie voix d'enfant. Ce travail devra être refait pour Windows et/ou iOS lors de leur ajout en V1, sur des moteurs de reconnaissance différents.
- **Lettre Z non reconnue par le modèle vocal léger, cause confirmée, correction non trouvée** : "zède" est absente du vocabulaire d'entraînement du modèle français `small` embarqué (message Vosk : "Ignoring word missing in vocabulary"). Contrairement à H/M/N/X (résolues par substitution d'un homophone français réel, transparent pour l'enfant — cf. section 12), aucun mot français courant ne se prononce "zède" ; le seul candidat en vocabulaire ("zed") est une prononciation anglaise/québécoise qui changerait ce que l'enfant doit dire. **Décision : laissé de côté pour l'instant** (option à ce stade : accepter "zed", ou un mode de réponse mixte vocal + tactile spécifique à Z, ce qui demanderait de rendre le mode de réponse configurable par question et non plus seulement par exercice, cf. 6.2).
- **Enchaînement du Comptage** : même en reconnaissance de mot isolé, il faut détecter correctement la fin de chaque chiffre prononcé avant d'écouter le suivant (éviter de couper l'enfant ou d'attendre trop longtemps), et déclencher la reprise depuis 1 sans frustrer l'enfant en cas d'erreur répétée — point d'attention pour le design de l'interaction, pas seulement pour la reconnaissance elle-même. Avec le plafond de 5 tentatives, le message de fin de séance doit aussi rester positif même si l'enfant termine ses 5 tentatives sans avoir dépassé 5 (score 0) — cohérent avec le principe général de bienveillance (cf. 6.7).
- **Confusions phonétiques prévisibles** : certaines lettres/chiffres se ressemblent à l'oral (ex. "b"/"d", "6"/"dix") ; le seuil de tolérance de la reconnaissance devra être calibré pour ne pas frustrer l'enfant par des faux rejets, ni valider des réponses fausses par excès de tolérance.
- **Confusions visuelles résiduelles malgré le plafond de rotation à 45°** : même avec des polices courantes et peu stylisées (Roboto, Verdana, Comic Sans MS), une combinaison particulière lettre/police/rotation pourrait encore rapprocher visuellement "b"/"d"/"p"/"q" ou "M"/"W" — jugé mineur et facilement ajustable au cas par cas pendant le développement, pas un point bloquant pour la suite.
- **Coût de contenu des polices et variantes visuelles** : le pool de polices utilisé pour les variantes aléatoires de l'Alphabet doit rester lisible pour de jeunes enfants (pas de police trop stylisée) tout en étant assez varié pour représenter un vrai défi — un travail de sélection/design distinct du développement logiciel.
- **Précision du temps de réponse en vocal** : pour un exercice vocal, le "temps de réponse" mesuré par la sélection adaptative (cf. 6.5) dépend en partie du temps de traitement de la reconnaissance vocale elle-même, pas seulement du temps de réflexion de l'enfant — la mesure devra isoler ces deux facteurs pour ne pas biaiser le calcul de difficulté.
- **Effet pervers possible de la sélection adaptative** : reposer plus souvent les questions difficiles peut accentuer la frustration si l'enfant échoue plusieurs fois de suite sur des questions proches (même si la même question précise n'est jamais répétée deux fois, cf. 6.5) ; à surveiller lors des premiers tests utilisateurs.
- **Seuils de récompense à calibrer par exercice** : même configurables par le parent, les valeurs par défaut fixées (10 questions, 7 s/4 s/2 s de moyenne par question, cf. 8.1) sont un point de départ unique appliqué à des exercices très différents (dire une lettre isolée vs. faire une addition ≤10) — un seuil "or" pourrait s'avérer inatteignable pour certains exercices ou trivial pour d'autres ; à valider empiriquement pendant les tests, pas seulement en théorie.
- **Motivation vs frustration sur une série de questions** : même avec la révélation après 2 échecs (cf. 8.1) qui évite un blocage indéfini, un enfant qui échoue beaucoup sur plusieurs questions d'une même série peut la trouver longue et décourageante avant d'obtenir sa récompense — à surveiller en test utilisateur.
- **Volume de contenu pour les messages de fin d'exercice** : pour éviter la répétition mot pour mot, chacun des 4 niveaux de score (0/bronze/argent/or) nécessite au moins 3 variantes de phrases, idéalement pré-enregistrées à la voix humaine plutôt qu'en synthèse vocale froide pour rester chaleureux — un coût de contenu/production à part entière, distinct du développement logiciel.
- **Calibrage du ton toujours positif** : trouver le bon équilibre pour qu'un message d'encouragement après une difficulté sonne sincère et motivant plutôt que condescendant ou artificiel est un travail d'écriture à tester avec de vrais enfants, pas seulement à valider sur le papier.
- **Algorithme de placement non-chevauchant (Dénombrement)** : générer une disposition aléatoire d'objets (position, orientation, taille) sans chevauchement est un développement à part entière (détection de collision, nouvelle tentative si une position ne convient pas, garantir un temps de calcul raisonnable sur un appareil d'entrée de gamme même avec le nombre maximal d'objets prévu).
- **Banque d'illustrations par catégorie (Dénombrement)** : contrairement aux autres exercices du MVP qui portent sur un contenu fixe et limité (lettres, chiffres, formes), Dénombrement nécessite de produire/acquérir des illustrations pour chaque catégorie d'objet (chats, tractopelles, etc.) — un coût de contenu à budgétiser, distinct du développement logiciel, et amené à grandir avec la bibliothèque (cf. 8.1).
- **Dépendance technique** : le choix du framework (ex. Flutter vs. React Native) doit supporter correctement l'audio, le stockage local volumineux (assets audio/images, données de performance par profil) et fonctionner sur des appareils Android d'entrée de gamme ; il doit aussi permettre d'ajouter Windows/iOS plus tard sans réécriture complète.

---

## 11. Prochaines étapes

1. ✅ **Spike technique prioritaire — fait, résultat positif.** Voir section 12 pour le détail. Reste à faire : tester avec une vraie voix d'enfant, sur les lettres et formes (seul un chiffre a été testé avec une voix adulte pour l'instant), et mesurer la fiabilité sur un jeu plus large de mots.
2. Passer à la conception détaillée : maquettes des écrans clés, pensées **tactile uniquement** — écran catalogue affiché à la création d'un profil, curation parentale avec ajout/retrait symétriques et slider du nombre de questions, vue enfant par matière/thème, exercice type (dont l'écran de reconnaissance vocale et l'écran de Dénombrement avec ses objets disposés aléatoirement), tableau de bord parental (dont les statistiques par question), écran de saisie du code PIN.
3. Choix technique de la stack (Flutter recommandé, en gardant Windows/iOS comme cibles futures faciles à ajouter) et du modèle de données local (profils, catalogue d'exercices, activations par profil, performances **par question**), en confirmant l'API de reconnaissance vocale retenue sur Android.
4. Concevoir/tester l'algorithme de placement aléatoire sans chevauchement pour Dénombrement (jusqu'à 10 objets pour la variante la plus large), et identifier une première banque d'illustrations par catégorie d'objet (chats, tractopelles, etc.).
5. Implémenter l'algorithme de sélection adaptative des questions (priorité aux questions jamais vues choisies aléatoirement, moyenne des 3 dernières tentatives avec pénalité de 5 s sur 2 échecs, non-répétition immédiate) — désormais entièrement spécifié.
6. Implémenter le système de récompenses avec les valeurs par défaut fixées (10 questions, 7 s/4 s/2 s de moyenne par question pour bronze/argent/or) pour les 11 exercices concernés (tous sauf Comptage), en prévoyant leur ajustement empirique par exercice pendant les tests.
7. Écrire les 3 variantes de messages de fin d'exercice pour chacun des 4 niveaux de score (0/bronze/argent/or), et prévoir leur enregistrement audio.
8. Produire le jeu d'illustrations "Grenouilles à lunettes" bronze/argent/or.

---

## 12. Résultats du spike technique (reconnaissance vocale)

**Date** : 2026-07-24. **Verdict** : faisabilité confirmée sur un premier test réel, à approfondir.

### Ce qui a été mis en place
- Projet Flutter initialisé dans `E:\Android_Projects\Funty` (Android uniquement, org `com.funty`), toolchain complète installée (Flutter 3.44.8, SDK Android avec cmdline-tools, licences acceptées).
- Package **`vosk_flutter_service`** intégré (reconnaissance vocale **hors-ligne**, open-source, Apache 2.0) — préféré à `speech_to_text` car ce dernier dépend de packs de langue Google potentiellement absents de l'appareil, ce qui ne garantit pas le hors-ligne exigé par le PRD.
- Modèle vocal français **`vosk-model-small-fr-0.22`** (41 Mo, Apache 2.0) embarqué comme asset de l'app.
- Écran de test (`lib/main.dart`) : affiche un chiffre aléatoire, écoute la réponse orale, la reconnaît via une **grammaire fermée** (liste des 10 mots-chiffres uniquement — le mécanisme exact requis par les exercices du PRD), et affiche le résultat plus le temps de réponse.

### Résultat du premier test
- Testé sur un téléphone physique (Samsung Galaxy S24, Android 16), par vous-même.
- Chiffre affiché : **3** → reconnu correctement comme **"trois"** en **1876 ms**, entièrement hors-ligne.
- Aucun crash, aucune erreur dans les logs.

### Ce que ça valide
- La chaîne technique complète fonctionne de bout en bout : modèle embarqué, reconnaissance hors-ligne, grammaire restreinte, mesure du temps de réponse.
- 1876 ms serait sous le seuil "bronze" par défaut (≤7 s, cf. 6.7) pour une voix adulte sur un mot isolé.

### Test systématique des 26 lettres majuscules (voix adulte)

**Premier passage : 21 lettres sur 26 reconnues correctement.** 5 échouent systématiquement (l'app affiche `[unk]`, la reconnaissance vocale ne reconnaît pas du tout le mot, plutôt que de se tromper de lettre) :

| Lettre | Mot attendu initialement | Résultat initial | Après correction |
|---|---|---|---|
| H | "ache" | ❌ `[unk]` | ✅ via homophone "hache" |
| M | "emme" | ❌ `[unk]` | ✅ via homophone "aime" |
| N | "enne" | ❌ `[unk]` | ✅ via homophone "haine" |
| X | "iks" | ❌ `[unk]` | ✅ via "ixe" (en vocabulaire, correspondance acoustique confirmée) |
| Z | "zède" | ❌ `[unk]` | ❌ toujours non résolu (aucun homophone français valide) |

**Cause confirmée, pas une simple hypothèse** : les logs natifs de Vosk affichent explicitement, pour chaque mot de la grammaire non reconnu :
```
Ignoring word missing in vocabulary: 'ache'
Ignoring word missing in vocabulary: 'emme'
Ignoring word missing in vocabulary: 'enne'
Ignoring word missing in vocabulary: 'iks'
Ignoring word missing in vocabulary: 'zède'
```
Ces 5 mots (noms de lettres peu courants en dehors du contexte d'épellation) sont **absents du vocabulaire d'entraînement** du modèle **small** (41 Mo, WER ~24-27%) — Vosk le dit lui-même, ce n'est pas une confusion acoustique. Les 21 autres lettres fonctionnent car leur nom se rapproche de mots réels courants du français (ex. "dé", "elle", "erre") que le modèle connaît bien.

**Tentative avec le modèle complet (`vosk-model-fr-0.22`, 1,4 Go) : non concluante, abandonnée.** Ce modèle a un vocabulaire plus large (WER ~13-15%) qui aurait pu résoudre ce point, mais son chargement a échoué pour une raison **indépendante et sans rapport** avec le vocabulaire : poussé sur le stockage externe de l'appareil (`/storage/emulated/0/Android/data/...`) via `adb push`, le code natif de Vosk (accès disque bas niveau en C++) ne parvient pas à lire les fichiers du modèle à cet endroit à cause de la couche de virtualisation de stockage d'Android (FUSE) — alors que Flutter/Dart, lui, voit bien les fichiers (deux couches d'accès différentes). Le modèle small fonctionne car il est chargé en stockage interne de l'app (`/data/user/0/...`), qui n'a pas cette restriction. Contourner ça aurait nécessité de repousser le modèle en stockage interne via `adb shell run-as` — jugé disproportionné : la confirmation du vocabulaire manquant était déjà acquise via les logs, et ce modèle de 2,3 Go décompressé n'est de toute façon pas envisageable pour une app mobile grand public. **Décision : ne pas poursuivre cette piste.**

**Correction par substitution homophone : 4 des 5 lettres résolues.** Le H étant muet en français, "ache" (H) se prononce exactement comme "hache" (l'outil) — un mot courant. Même logique pour "emme"≈"aime" (M) et "enne"≈"haine" (N) : des homophones réels, confirmés présents dans le vocabulaire du modèle via une sonde (ajout de ces mots à la grammaire, vérification dans les logs Vosk qu'ils ne sont *pas* listés comme "missing"). La grammaire cible désormais ces mots à la place, **sans rien changer à ce que l'enfant doit dire** — la substitution est purement interne/technique. Pour X, "ixe" (sans lien étymologique évident, mais confirmé en vocabulaire) s'est avéré acoustiquement correspondre à "iks" en test réel.

**Résultat retesté avec voix adulte : 25 lettres sur 26 fonctionnent.** Seul **Z** reste non résolu : aucun mot français courant ne se prononce "zède" pour servir d'homophone. Le seul candidat en vocabulaire est "zed" (prononciation anglaise/québécoise), qui **changerait ce que l'enfant doit dire** (pas une substitution transparente comme pour H/M/N) — ce n'est donc pas la même catégorie de correction. **Décision : laissé de côté pour l'instant**, à retrancher plus tard parmi les options déjà identifiées (accepter "zed", mode vocal + tactile spécifique à Z avec mode de réponse configurable par question, ou autre piste).

### Ce qui reste à valider (ne pas considérer comme acquis)
- **Voix d'enfant** : tous les tests ont été faits avec une voix adulte. La reconnaissance d'un enfant de PS/MS (articulation moins nette) reste le risque principal identifié en section 10 — à tester en priorité, y compris sur les 25 lettres qui fonctionnent avec une voix adulte (les homophones de substitution comme "hache"/"aime"/"haine" restent à valider avec une voix d'enfant).
- **Chiffres** : un seul chiffre testé pour l'instant (le parcours systématique n'a été fait que sur les lettres) ; à refaire sur les 10 chiffres.
- **Minuscules, formes, variantes tournées/police aléatoire** : pas encore testées.
- **Confusions phonétiques** (ex. "b"/"d", "6"/"dix", cf. section 10) : pas encore testées spécifiquement (les échecs observés sont des non-reconnaissances, pas des confusions avec une autre lettre).
- **Point technique résolu au passage** : le plugin `vosk_flutter_service` fixe `compileSdk=33` dans son propre `build.gradle`, incompatible avec ses dépendances androidx qui exigent 34+. Contournement appliqué dans `android/build.gradle.kts` (force `compileSdk=36` sur tous les modules via un hook `afterEvaluate`) — à surveiller si une mise à jour du plugin corrige ça nativement.
