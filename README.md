# lb_library

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## API server

The app uses `http://10.0.2.2:8080/` by default on the Android emulator
(`10.0.2.2` reaches the host computer from the emulator), and
`http://192.168.1.7:8080/` on other targets. On a physical Android or iOS device,
the API host must be reachable over the local network, and the backend must
listen on a network interface (not only `localhost`). If the computer's LAN IP
or port differs, override the URL:

```sh
flutter run --dart-define=API_BASE_URL=http://<computer-lan-ip>:8080/
```

Loopback API overrides (`localhost` or `127.0.0.1`) are automatically mapped to
`10.0.2.2` on Android, since emulator loopback addresses refer to the emulator
itself.

The mobile development configurations allow cleartext HTTP for this local API.
Use HTTPS and remove those cleartext allowances before shipping a production
build. For device-only failures, check the `[NetworkAPI]` debug log for the
request URL and Dio connection error type; request bodies and tokens are not
logged.
