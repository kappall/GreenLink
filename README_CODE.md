# Struttura del Codice e Panoramica del Progetto

Questo documento fornisce una panoramica della struttura del codice sorgente dell'applicazione GreenLink.

## Architettura Generale

L'applicazione segue un'architettura orientata alle funzionalità (**Feature-based**), dove il codice è organizzato in base alle diverse funzionalità dell'app. Questo approccio promuove la modularità e la manutenibilità del codice.

La gestione dello stato è affidata a **Riverpod**, un sistema di dependency injection e state management per Flutter. Questo permette di gestire lo stato dell'applicazione in modo reattivo e disaccoppiato.

## Struttura delle Cartelle

Il codice sorgente principale si trova nella cartella `lib`. Di seguito è descritta la struttura delle sottocartelle principali:

-   `lib/`
    -   `main.dart`: Il punto di ingresso dell'applicazione. Qui viene inizializzata l'app e il provider scope di Riverpod.
    -   `router.dart`: Contiene la configurazione della navigazione dell'app, gestita tramite il pacchetto `go_router`.

### `lib/core`

Questa cartella contiene la logica di base e i componenti condivisi tra le diverse funzionalità dell'applicazione.

-   **`constants`**: Contiene costanti globali, come chiavi API, route, o valori di configurazione.
-   **`services`**: Servizi globali come client HTTP, gestione della geolocalizzazione, o interazioni con API esterne.
-   **`utils`**: Funzioni di utilità e classi helper riutilizzabili in tutto il progetto.
-   **`widgets`**: Widget generici e riutilizzabili che non appartengono a una funzionalità specifica (es. pulsanti personalizzati, loader).

### `lib/features`

Questa è la cartella più importante e contiene il cuore dell'applicazione, organizzato per funzionalità. Ogni sottocartella rappresenta una funzionalità specifica e di solito contiene:

-   **`models`**: Le classi di modello (data classes) che rappresentano i dati della funzionalità.
-   **`providers`**: I provider di Riverpod che gestiscono lo stato della funzionalità e forniscono l'accesso ai dati.
-   **`pages`**: Le pagine o schermate dell'interfaccia utente (UI) relative alla funzionalità.
-   **`widgets`**: Widget specifici per la funzionalità, utilizzati per costruire le pagine.
-   **`services`** o **`repositories`**: La logica di business e le interazioni con le fonti di dati (API, database locale) per la funzionalità.

### `lib/theme`

Questa cartella contiene tutto ciò che riguarda lo stile e il tema dell'applicazione.

-   **`app_theme.dart`**: Definizione del tema principale dell'app, inclusi colori, stili di testo e altri attributi visivi.

## Dipendenze Chiave

-   **`flutter_riverpod`**: Per la gestione dello stato e la dependency injection.
-   **`go_router`**: Per la navigazione e il routing.
-   **`freezed`**: Per la creazione di modelli di dati immutabili e la gestione delle unioni (unions).
-   **`http`**: Per le richieste di rete.