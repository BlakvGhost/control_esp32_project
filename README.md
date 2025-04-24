
# Control ESP32 - Mobile Flutter App

Application Flutter permettant de contrôler un module ESP32 via des requêtes HTTP simples. Elle permet notamment de gérer l’éclairage (interne/externe), l’alarme, et le mode de fonctionnement (manuel ou automatique).

🔗 Repo GitHub : [https://github.com/BlakvGhost/control_esp32_project](https://github.com/BlakvGhost/control_esp32_project)

---

## Objectif du projet

Ce projet a été conçu dans le cadre d’un module pédagogique. L’objectif est de permettre aux étudiants de comprendre :

- la communication entre une application mobile et un microcontrôleur (ESP32)
- la gestion des états via des requêtes HTTP
- la mise en place d’une interface intuitive Flutter
- la persistance locale avec SharedPreferences

---

## Fonctionnalités

L’application mobile permet de :

- ✅ Activer/désactiver les lampes internes et externes
- 🚨 Activer/désactiver l’alarme
- 🔁 Passer d’un mode manuel à un mode automatique
- 📡 Interroger l’état actuel des lampes, de l’alarme et du mode
- 💾 Sauvegarder l’adresse IP et le port de l’ESP32 localement

---

## Aperçu de l’architecture

📦 Flutter App

- UI en Flutter (Material Design)
- Utilisation de SharedPreferences pour mémoriser l’IP/port de l’ESP32
- Requêtes HTTP via le package http

🖧 ESP32 (non inclus dans le repo)

- Serveur web HTTP minimal embarqué
- Réponses JSON
- Routes simples (GET)

---

## Exemple d’API côté ESP32

L’ESP32 doit exposer les routes suivantes :

| Route                  | Méthode | Description                           | Réponse attendue         |
|------------------------|---------|---------------------------------------|--------------------------|
| /mode/auto             | GET     | Active le mode auto                   | 200 OK                   |
| /mode/manuel           | GET     | Active le mode manuel                 | 200 OK                   |
| /mode/etat             | GET     | Retourne le mode actif                | { "etat": "auto" }       |
| /lamp/in/on            | GET     | Allume les lampes internes            | 200 OK                   |
| /lamp/in/off           | GET     | Éteint les lampes internes            | 200 OK                   |
| /lamp/in/etat          | GET     | État des lampes internes              | { "etat": "on" }         |
| /lamp/out/on           | GET     | Allume les lampes externes           | 200 OK                   |
| /lamp/out/off          | GET     | Éteint les lampes externes           | 200 OK                   |
| /lamp/out/etat         | GET     | État des lampes externes             | { "etat": "off" }        |
| /alarm/on              | GET     | Active l’alarme                       | 200 OK                   |
| /alarm/off             | GET     | Désactive l’alarme                    | 200 OK                   |
| /alarm/etat            | GET     | État de l’alarme                      | { "etat": "on" }         |

📝 Toutes les routes doivent retourner une réponse JSON de la forme :  

```json
{ "etat": "on" }
```

---

## Installation & Lancement

1. Clone le dépôt :

```bash
git clone https://github.com/BlakvGhost/control_esp32_project.git
cd control_esp32_project
```

2. Lancer l'application :

```bash
flutter pub get
flutter run
```

> 💡 N’oublie pas de configurer l’IP et le port de l’ESP32 dans l’app avant utilisation.

---

## Exemple de code Flutter : appel API

```dart
final response = await http.get(Uri.parse('http://192.168.1.1:3333/lamp/in/on'));
if (response.statusCode == 200) {
  print("Lampes internes allumées !");
}
```

---

## Structure

```
/lib/
├── services/
│   └── api_service.dart     # Requêtes HTTP vers l'ESP32
├── screens/
│   └── home_screen.dart     # Interface principale
├── widgets/
│   └── controls.dart        # Boutons de commande
```

---

## Prochaines améliorations

- Ajout de feedback visuel (SnackBars, loaders)
- Support MQTT (en alternative au HTTP)
- Mode hors-ligne + simulation
- Tests unitaires avec mockito

---

## Licence

Ce projet est open-source sous licence MIT.  
Tu peux l’utiliser, l’adapter et l’améliorer librement.

---

Made with ❤️ by [BlakvGhost](https://username-blakvghost.com).
