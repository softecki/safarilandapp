# WhatsLipa

**WhatsLipa** = WhatsApp Commerce + Payments + Delivery + Customer Management.

Mobile app (Flutter) for staff to manage the same **SokoFresh / AFM portal** (`afm_portal`) and **LotiGas**-style operations from one place.

**Developed by Softecki Group Company Limited.**

## Architecture

| Layer | Project | Role |
|-------|---------|------|
| Mobile app | `afm_masterapp` (this repo) | WhatsLipa UI — login, dashboard, module launcher |
| API + portal | `afm_portal` | Laravel — `/api/whatslipa/*`, `/sokofresh/*` web UI |
| Alternate deploy | `lotigas` | Same codebase family as portal (LotiGas branding) |

Staff sign in with the **same email/phone + password** as the web portal. Modules open the live portal inside a secure **WebView bridge** (short-lived token → web session).

## Setup

1. Run **afm_portal** locally (`php artisan serve`, migrate, seed `SfRbacSeeder`).
2. In the app: **Server settings** → set `APP_URL` (e.g. `http://10.0.2.2:8000` on Android emulator).
3. Sign in with a user that has a **SokoFresh role** (admin, facilitator, delivery, etc.).

## API (afm_portal)

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/whatslipa/login` | Email or phone + password → Sanctum token + menu |
| GET | `/api/whatslipa/me` | Current user + menu (Bearer token) |
| GET | `/api/whatslipa/dashboard` | KPIs for native dashboard |
| POST | `/api/whatslipa/bridge` | Create WebView session URL |
| GET | `/whatslipa/bridge/{token}` | Exchange token → logged-in redirect |

Env: `WHATSLIPA_ENABLED`, `WHATSLIPA_BRIDGE_TTL` — see `afm_portal/.env.example`.

## App modules (from portal permissions)

Dashboard (native), Orders, WhatsApp Inbox, Customers, Delivery, Products, Packages, Locations, WhatsApp/SMS marketing, Reports, Facilitator, Operator, Users, Mobile inbox web, Public shop.

## Other modes

From login screen / legacy flows: **Gate Access** and **Employee** (attendance) remain available via mode selector for workforce use.

## Build

```bash
flutter pub get
flutter run
```
