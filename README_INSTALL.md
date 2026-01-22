# Istruzioni per l'Installazione (Android)

## Prerequisiti

Prima di iniziare, assicurati di avere installato sul tuo computer i seguenti strumenti:

1.  **Flutter SDK:** Assicurati di avere una versione recente di Flutter. Puoi seguire la [guida ufficiale di Flutter](https://docs.flutter.dev/get-started/install) per l'installazione.
2.  **Android Studio:** Necessario per l'SDK di Android, il compilatore e gli strumenti a riga di comando. Assicurati di configurare un emulatore o di avere un dispositivo fisico collegato con il debug USB abilitato.
3.  **Git:** Per clonare il repository del progetto.

## Passaggi per l'installazione

1.  **Clonare il Repository**

    Apri un terminale e clona il repository del progetto utilizzando il seguente comando, e quando chiesto inserire le credenziali fornite:


    ```bash
    git clone https://gitea-greenlink.tommasodeste.it/MissionPossible/app.git
    cd app
    ```

2.  **Installare le Dipendenze**

    Una volta dentro la cartella del progetto, esegui il seguente comando per scaricare tutte le dipendenze necessarie definite nel file `pubspec.yaml`:

    ```bash
    flutter pub get
    ```

3.  **Eseguire l'Applicazione**

    Assicurati di avere un dispositivo Android collegato o un emulatore in esecuzione. Poi, esegui l'applicazione con il seguente comando:

    ```bash
    flutter run
    ```

    Questo comando compilerà l'applicazione e la installerà sul dispositivo/emulatore.

## Buildare e Installare l'APK

Se hai bisogno di generare un file APK per l'installazione manuale o la distribuzione, segui questi passaggi:

1.  **Buildare l'APK**

    Esegui il seguente comando per creare un pacchetto APK:

    ```bash
    flutter build apk --release
    ```

    L'APK generato si troverà nella cartella `build/app/outputs/flutter-apk/app-release.apk`.

2.  **Installare l'APK su un Dispositivo**

    Per installare l'APK su un dispositivo collegato, usa `adb` (Android Debug Bridge). Assicurati che `adb` sia nel tuo PATH di sistema.

    ```bash
    adb install build/app/outputs/flutter-apk/app-release.apk
    ```

## Risoluzione dei problemi

-   Se incontri problemi relativi a dipendenze o versioni di Flutter, prova ad eseguire `flutter doctor` per diagnosticare problemi comuni con la tua installazione di Flutter.
-   Assicurati che il tuo dispositivo Android sia correttamente riconosciuto da `adb devices`.
