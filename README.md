# Installation

## Voraussetzungen

Zur Installation der iOS-App werden benötigt

- MacOS
- Xcode (+ Simulator)
- Flutter (https://flutter.io/docs/get-started/install)
- ggf. Flutter IDE-Plugin (https://flutter.io/docs/get-started/editor)

Alternativ kann die App unter Windows / Linux als Android-App ausgeführt werden, für diese Plattform wurde aber nicht getestet.

Falls die App auf einem physikalischen Gerät ausgeführt werden soll wird eine Apple Developer ID benötigt. Hierzu muss das Signing manuell in Xcode-Projekt angepasst werden.

## Bauen mit Flutter und Visual Studio Code Plugin

Öffnen Sie einfach den Projekt-Ordner (also den Root-Ordern dieses Repositories) in Visual Studio Code und wählen sie 'Debug > Start Debugging'. Die App sollte automatisch kompiliert und auf dem gewählten Gerät gestartet werden.

## Bauen mit Flutter von der Befehlszeile

Führen Sie auf der Befehlszeile 

> flutter run

aus. Falls mehrere Geräte verfügbar sind, führen Sie erst

> flutter devices

aus, wählen Sie die gewünschte Device ID und geben diese beim Aufruf des `run` Befehls mit der -d Option an.