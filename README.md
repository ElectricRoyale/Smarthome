# Smarthome

A Flutter dashboard app for [Home Assistant](https://www.home-assistant.io/). Control lights, shutters, climate, media and appliances from one dark-themed, mobile-first interface, with live updates over the Home Assistant WebSocket API.

## Features

- **Live device state**: subscribes to `state_changed` events via the Home Assistant WebSocket API
- **Server discovery**: finds Home Assistant instances on the local network via mDNS (Bonsoir), with manual address entry as fallback
- **Room overview**: devices grouped by room with a customizable dashboard
- **Dedicated control panels** for:
  - Lights (color wheel, brightness, effects)
  - Sockets / switches
  - Shutters / covers
  - Air conditioning / fans
  - Heating systems
  - Media players and AV receivers
  - Kitchen appliances and washing machines
  - Irrigation
- **Weather**: multiple saved locations with current conditions
- **Spotify**: playback control and playlist browsing
- **Energy statistics**: usage charts per device
- **Logbook**: recent Home Assistant events
- **Network tools**: LAN scan, ping and speed test
- **Security**: biometric authentication on app start
- **Localization**: English and German

## Platforms

Android, iOS, Web, Linux and macOS (Flutter multi-platform project). Primary target is mobile (portrait).

## Tech stack

| Area | Packages |
| --- | --- |
| Framework | Flutter (Dart SDK `>=3.0.6 <4.0.0`) |
| Home Assistant | `web_socket_channel`, `http`, `oauth2` |
| Discovery / network | `bonsoir`, `lan_scanner`, `dart_ping`, `speed_test_dart` |
| Local storage | `hive`, `hive_flutter` |
| Charts | `syncfusion_flutter_charts` |
| Media | `spotify`, `spotify_sdk`, `palette_generator` |
| Auth / device | `local_auth`, `geolocator`, `permission_handler` |
| i18n | `flutter_localizations`, `intl` |

## Getting started

### Prerequisites

- Flutter SDK (stable) with a Dart version matching `pubspec.yaml`
- A running Home Assistant instance reachable from your device
- A Home Assistant [long-lived access token](https://www.home-assistant.io/docs/authentication/#your-account-profile)

### Installation

```bash
git clone https://github.com/<your-username>/Smarthome.git
cd Smarthome
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### First launch

1. Select your Home Assistant server from the discovery list, or enter its address manually (e.g. `http://192.168.1.10:8123`).
2. Provide your access token when prompted.
3. Pick your devices and rooms on the dashboard.

## Project structure

```
lib/
├── JSON/        # Home Assistant payload models
├── Model/       # Hive models (user data, weather locations)
├── l10n/        # ARB translation files (en, de)
├── layouts/     # Pages and widgets
│   ├── CarouselSliderItems/   # Dashboard carousel (weather, devices, media, logbook)
│   └── controllpanels/        # Per-device-type control panels
└── utils/       # Connection handling, Spotify, color picker, helpers
assets/          # SVG icons (rooms, devices, weather, light effects)
```

## Security notes

- Never commit access tokens or database credentials. Keep them out of the repository and load them at runtime or via environment configuration.
- Prefer `https://` / `wss://` when exposing Home Assistant beyond your local network.

## Roadmap

- [ ] Automations editor
- [ ] Statistics page
- [ ] Secure token storage

## Contributing

Issues and pull requests are welcome. Please open an issue first to discuss larger changes.

## License

Add a license of your choice (e.g. MIT) as `LICENSE` and reference it here.
