# Cupping Therapy

Flutter client for the Hijama/cupping therapy service.

## Laravel API configuration

The app uses the Laravel `/api/v1` API. Configure its origin with the
`API_BASE_URL` Dart define; do not include a resource path:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1/
```

`10.0.2.2` reaches the host computer from the Android emulator. For a physical
device, use the development computer's LAN address, for example:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8000/api/v1/
```

Use the deployed HTTPS API URL for production builds. Debug Android builds
allow cleartext traffic for local development only; release builds require
HTTPS. The app maps `localhost` image URLs returned by the local API to the
configured API host so Laravel storage images work on emulators and devices.

The client currently integrates authentication and profile/session, therapy
services, appointments, training programs/enrollments, the home gallery, and
contact inquiries. API response field documentation is still needed to bind the
banners and public business-settings endpoints safely.
