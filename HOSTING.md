# PAMOJA AFCON 2027 — Demo hosting

Three front ends share Visual Brand Guide v1.1 (Lake `#00A9D6`, Indigo `#173B63`, Montserrat) and the Core Super App FR/NFR v8 journeys.

| Surface | Folder | Stack | Demo URL (local) |
|---|---|---|---|
| Fan Super App (Android / iOS / web) | `C:\xampp\htdocs\project\pamojaapp` | Flutter | Chrome: `flutter run -d chrome` |
| Fan website + web app | `C:\xampp\htdocs\project\pamojaweb` | Next.js 16 | http://localhost:3000 |
| Admin / OPS portal | `C:\xampp\htdocs\project\pamojadmin` | Next.js 16 | http://localhost:3001 |

## Linux server

Step-by-step Ubuntu deploy (nginx, systemd, text-file database):

**[DEPLOY-LINUX.md](DEPLOY-LINUX.md)**

Copy that file to the server (`/opt/pamoja/DEPLOY-LINUX.md`) and follow it. OPS data lives in `pamojadmin/data/*.txt` and must be writable.

## Demo accounts

**Fan (web + mobile)**  
- Enter demo as Amina, or login then OTP `481028`  
- Password: `Pamoja2027`

**Admin**  
- Email: `admin@pamoja.africa`  
- Password: `Pamoja2027!`  
- Switch the 8 access levels from the header (Super, Country, Government, Immigration, Tourism, Event, Finance, Support).

All data is local/demo. Government, wallet and betting APIs are sandbox/mock as specified for MVP.

## 1. Fan website (pamojaweb)

```bat
cd C:\xampp\htdocs\project\pamojaweb
npm install
npm run dev
```

Opens http://localhost:3000 — landing, Fan ID registration, portal modules (wallet, eVisa, Match Centre, FanVerse, SwifPack, tickets, SOS).

### Host for stakeholders (Vercel)

1. Create a GitHub repo for `pamojaweb` (or push this folder).
2. https://vercel.com/new → Import the repo.
3. Framework: Next.js. Build `next build`. Output default.
4. Add domain later (e.g. `pamoja.africa` / `www`).

Or export a static preview after `npm run build` and `npm run start` on a VM.

## 2. Admin portal (pamojadmin)

```bat
cd C:\xampp\htdocs\project\pamojadmin
npm install
npm run dev -- --port 3001
```

Opens http://localhost:3001/login then OPS dashboard, Fan ID queue, visas, mini-program registry, wallet, moderation, teams/media/groups, integrations, audit.

### Host for stakeholders (Vercel)

Same as web. Suggested hostname: `ops.pamoja.africa`.

## 3. Mobile Super App (pamojaapp)

```bat
cd C:\xampp\htdocs\project\pamojaapp
flutter pub get
flutter run
```

Chrome/Edge:

```bat
flutter run -d chrome
```

Android emulator / device:

```bat
flutter run -d android
```

Web build for XAMPP / any static host:

```bat
flutter build web --release --base-href /pamojaapp/
```

Copy `build/web` into `C:\xampp\htdocs\pamojaapp` and open http://localhost/pamojaapp/

### Host Flutter web (Firebase / Nginx / XAMPP)

- **XAMPP:** copy `build/web` to `htdocs/pamoja`.
- **Firebase:** `firebase init hosting` → public `build/web`.
- **Vercel/Netlify:** publish the `build/web` folder as static files.

## Suggested demo script

1. Open the website landing (TZ/KE/UG).  
2. Get Fan ID → OTP → Home.  
3. Show Fan ID QR, Traveller wizard, eVisa sandbox, Wallet top-up, SwifPack ride, Match Centre predict/vote/pulse, FanVerse.  
4. Open OPS as Super admin, then switch to Immigration admin.  
5. Walk approvals, integration health (Sandbox/Mock/Live), audit.

## Production notes (not required for demo)

Core APIs, Tanzania data residency, VPN to Immigration/NIDA, Unlimit wallet, NMB/NBC settlement, WhatsApp and CI/CD remain backend/infrastructure work (iVisionGate + Omni Horizon). These UIs are API-ready and currently run on a demo store so hosting does not block stakeholder review.
