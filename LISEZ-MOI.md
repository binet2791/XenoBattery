# Xéno Batterie — prototype personnel

Une petite app SwiftUI avec un xénomorphe dessiné en vectoriel, une Live Activity et les présentations compacte, minimale et agrandie de la Dynamic Island. Compatible avec iOS 17 et versions ultérieures; destiné ici à ton iPhone 17.

## Installer sur ton iPhone

Il faut un **Mac avec Xcode compatible avec la version d’iOS de ton iPhone**. Le PC Windows ne peut pas compiler ce projet avec les outils Apple. L’archive contient les sources et le projet; ce n’est pas une app signée à installer directement depuis Fichiers.

1. Décompresse l’archive sur le Mac et ouvre `XenoBattery.xcodeproj`.
2. Dans Xcode > Settings > Accounts, ajoute ton compte Apple.
3. Sélectionne le projet, puis chacune des deux cibles `XenoBattery` et `XenoLiveActivity`. Dans Signing & Capabilities, garde Automatically manage signing et sélectionne la même Team pour les deux.
4. Si les identifiants sont déjà pris, remplace `com.sabin.xenobattery` par un identifiant unique pour l’app, et utilise cet identifiant suivi de `.liveactivity` pour l’extension.
5. Branche ton iPhone, accepte « Faire confiance » si demandé, sélectionne-le comme destination. Active le mode développeur si Xcode le demande (Réglages > Confidentialité et sécurité > Mode développeur; redémarrage requis).
6. Sélectionne le scheme `XenoBattery` et lance avec ▶ ou Cmd-R.
7. Ouvre l’app, touche **Afficher mon xénomorphe** et autorise les activités en direct si iOS le demande.
8. Retourne à l’écran d’accueil pour voir l’îlot. Maintiens la Dynamic Island pour l’agrandir; verrouille le téléphone pour voir la carte.

Un compte Apple gratuit permet les essais personnels avec une Personal Team. Les profils gratuits expirent après sept jours : relance l’installation depuis Xcode pour renouveler. Aucune inscription payante ni publication App Store n’est prévue pour ce prototype local. TestFlight serait une autre procédure avec une adhésion au programme développeur.

## Ce que fait la version 1

- Pose recroquevillée : 0–20 %.
- Pose normale avec queue relevée : 21–79 %.
- Bras levés : 80–99 %.
- Gueule ouverte avec petite seconde mâchoire : 100 %.
- Indicateur de charge, heure de mesure et état « à actualiser ».
- Quatre boutons pour essayer des niveaux fictifs. Le mode démo est indiqué sur la carte et dans l’îlot compact.
- Respiration en boucle dans l’app, désactivée si Réduire les animations est actif.
- Démarrage, récupération d’une activité existante, actualisation et suppression. Le prototype évite les activités en double.

L’app lit la vraie batterie au démarrage et à chaque retour au premier plan. Elle traite les notifications de batterie pendant son exécution et vérifie aussi toutes les 30 secondes lorsqu’elle est au premier plan. Les boutons de démo mettent à jour une activité déjà démarrée. Une nouvelle mesure rétablit la valeur réelle.

## Limites concrètes

**La Dynamic Island n’exécute pas une animation de personnage en boucle.** Le prototype change de pose et utilise les transitions système lorsque le contenu est mis à jour. Les courtes animations sont gérées par iOS; l’affichage Always-On peut rester immobile.

**La batterie ne reste pas mesurée en continu en arrière-plan.** Une Live Activity ne donne pas à l’app le droit de fonctionner indéfiniment. Sans exécution de l’app, pas de nouvelle lecture locale. Un serveur ne pourrait pas lire la batterie du téléphone à sa place. Après cinq minutes sans mise à jour, le contenu est déclaré périmé et l’interface peut indiquer « Mesure à actualiser ». L’heure de mesure reste visible dans les vues larges; ce délai n’est pas une promesse de réveil ou d’actualisation à la seconde près.

Touche la carte ou l’îlot pour ouvrir l’app et actualiser. Il n’y a pas de lancement automatique au branchement dans cette version, ni d’automatisation Raccourcis intégrée.

Une Live Activity peut durer au maximum huit heures. iOS peut conserver ensuite la carte sur l’écran verrouillé pendant jusqu’à quatre heures supplémentaires. Il faut revenir dans l’app pour relancer une activité; le prototype ne contourne pas ces limites.

Le xénomorphe reste à l’intérieur des zones allouées par iOS. Il ne remplace pas l’icône de batterie, ne sort pas du contour de la Dynamic Island et ne se superpose pas librement aux autres apps.

## Vérification sur Mac et iPhone

La génération et les vérifications structurelles ont été faites dans un environnement sans Xcode. **Compilation, rendu Apple et fonctionnement sur iPhone restent à vérifier.** Aucun fichier IPA signé n’est fourni.

Pour compiler d’abord sur simulateur depuis le dossier du projet :

```sh
xcodebuild -project XenoBattery.xcodeproj -scheme XenoBattery -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build
```

Pour un test complet sur l’iPhone :

1. Démarrer, revenir à l’accueil, agrandir l’îlot, puis verrouiller.
2. Essayer 10, 50, 90 et 100 %; vérifier les poses et la mention Démo.
3. Actualiser et comparer la valeur à la vraie batterie du téléphone.
4. Revenir dans l’app, redémarrer l’activité et vérifier qu’une seule carte existe.
5. Quitter au premier plan, attendre plus de cinq minutes et contrôler l’heure de mesure et l’état périmé.
6. Tester l’affichage Always-On, une autre Live Activity concurrente et Réduire les animations.
7. Retirer le xénomorphe et vérifier sa disparition des deux surfaces.
8. Désactiver les activités en direct pour cette app et vérifier le message au démarrage.

## Organisation

`App/` : interface et lecteur de batterie. `Shared/` : données ActivityKit et dessin vectoriel compilés dans les deux cibles. `LiveActivity/` : extension WidgetKit. Aucun serveur, notification push, groupe d’apps ou dépendance externe.

## Documentation Apple

- https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
- https://developer.apple.com/design/human-interface-guidelines/live-activities
- https://developer.apple.com/support/compare-memberships/

Projet personnel de fan, sans affiliation officielle.
