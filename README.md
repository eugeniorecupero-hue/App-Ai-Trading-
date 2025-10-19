# Atlas AI Trader - Intelligent Market Assistant

Questo repository contiene il prototipo dell'applicazione mobile **Atlas AI Trader**, un assistente intelligente per l'analisi dei mercati finanziari, sviluppato con Flutter per il frontend e FastAPI (mock) per il backend.

## 🎯 Obiettivo del Progetto

L'obiettivo di questo prototipo è dimostrare le funzionalità principali di un'app in stile chat AI che accetta input naturali, analizza dati di mercato (mock), genera segnali di trading (mock) e offre un'interfaccia utente moderna e fluida.

## 🧩 Architettura

- **Frontend:** Flutter (Dart)
- **Backend (Mock):** FastAPI Python (microservizio)
- **Database (Mock):** SQLite (per dati locali)
- **Notifiche (Mock):** Firebase Cloud Messaging (FCM)

## 🚀 Come Eseguire il Progetto

### Prerequisiti

Assicurati di avere installati:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Python 3.8+](https://www.python.org/downloads/)
- `pip` per Python

### 1. Clona il Repository

```bash
git clone <URL_DEL_REPOSITORY>
cd atlas_ai_trader
```

### 2. Configura e Avvia il Backend (Mock)

Il backend FastAPI fornisce dati mock per segnali, mercati, portafoglio e notizie. È essenziale che sia in esecuzione affinché l'app Flutter possa recuperare i dati.

```bash
cd backend
pip install -r requirements.txt
python main.py
```

Il backend sarà disponibile su `http://localhost:8000`. Assicurati che il tuo emulatore o dispositivo Android possa accedere a questo indirizzo (potrebbe essere necessario configurare il port forwarding o usare l'indirizzo IP del tuo computer sulla rete locale).

### 3. Configura e Avvia il Frontend Flutter

#### Installazione delle Dipendenze

```bash
cd .. # Torna alla directory principale del progetto (atlas_ai_trader)
flutter pub get
```

#### Configurazione di Firebase (Solo per Notifiche Reali)

Questo prototipo include l'integrazione mock di Firebase. Per abilitare le notifiche push reali, dovrai configurare Firebase nel tuo progetto Flutter:

1. Crea un nuovo progetto Firebase nella [Firebase Console](https://console.firebase.google.com/).
2. Aggiungi un'app Android al tuo progetto Firebase.
3. Scarica il file `google-services.json` e posizionalo in `android/app/`.
4. Segui le istruzioni per aggiungere il plugin Gradle di Firebase.
5. Abilita Cloud Messaging nella console Firebase.

#### Esecuzione dell'App

Per eseguire l'app su un emulatore o un dispositivo fisico:

```bash
flutter run
```

### 4. Compilazione dell'APK Debug

Per generare un APK debug installabile:

```bash
flutter build apk --debug
```

L'APK generato si troverà in `build/app/outputs/flutter-apk/app-debug.apk`.

**Nota:** La compilazione dell'APK richiede un ambiente Android SDK completamente configurato. Se incontri problemi, assicurati che `ANDROID_HOME` sia impostato correttamente e che tutti i componenti SDK necessari siano installati tramite `sdkmanager`.

## 🎨 UI/UX Mockup (Descrizione Testuale)

L'applicazione segue un design **dark mode** (`#0F1115`) con accenti **blu** (`#3B82F6`) e **verdi** (`#10B981`).

### Schermate Principali:

1.  **Splash Screen:** Logo Atlas AI Trader con animazione di caricamento.
2.  **Home Screen (Navigation Bar):** Contiene 5 sezioni principali:
    *   **Chat:** Interfaccia di conversazione con l'AI. Input utente, risposte formattate, bottoni rapidi e icona '?' per la guida.
    *   **Mercati:** Tabs per Crypto, FX, Indici, Azioni, Commodities. Mostra top movers con prezzo, % di variazione e mini-grafico.
    *   **Segnali:** Storico dei segnali con stato (attivo, chiuso, SL/TP), filtri per asset class/orizzonte e confidenza colore-coded.
    *   **Portafoglio (Paper Trading):** Posizioni correnti, P/L %, equity curve, metriche (Sharpe, MaxDD, hit-rate, RR medio) e possibilità di chiudere posizioni.
    *   **News:** Feed di notizie finanziarie con sentiment sintetico (emoji) e link alle fonti originali.

## 📚 Guida all'Uso (Sezione Interna)

Accessibile tramite l'icona '❓' nella chat. Fornisce istruzioni dettagliate su come chiedere segnali, scansioni, news e gestire le posizioni.

## 🧾 Consegna

- **Link download APK (Debug):** (Sarà fornito un link pubblico dopo la compilazione, se possibile).
- **Anteprima Visiva (Mockup UI):** Descrizione testuale dettagliata dell'interfaccia utente.
- **README:** Questo documento con istruzioni complete per setup e utilizzo.

## ✅ Test Finali (Manuali)

1.  Apri app → digita "BTC 1h" → mostra segnale completo.
2.  `/scan crypto` → mostra top 5 opportunità.
3.  `/portfolio` → mostra posizioni mock.
4.  `/news` → mostra 3 headline con sentiment.
5.  "❓" → mostra guida all'uso.

