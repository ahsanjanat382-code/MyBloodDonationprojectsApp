# BloodLink — Blood Donation App (Flutter)

## Included
- Modern home dashboard
- Donor search with blood-group filters
- Blood request screen and request form
- Profile screen with demo edit dialogs
- Local demonstration records for Jalalabad

## Important
This is a runnable UI prototype. It does **not** connect to a server, save requests permanently, send notifications, or contact donors. The donor names and requests are demo data. Do not use it for real emergency coordination until a secure backend, verified donor consent, authentication, and medical safety review are implemented.

## Build an APK on Windows
1. Install Flutter SDK and Android Studio (including Android SDK).
2. Extract this project folder.
3. Open PowerShell inside the `blood_donation_app` folder.
4. Run:
   ```powershell
   flutter doctor
   flutter pub get
   flutter build apk --release
   ```
5. The APK will be created at:
   `build\app\outputs\flutter-apk\app-release.apk`

If Android Studio asks to install Android SDK components, accept and finish installation first.
