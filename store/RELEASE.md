# Release & Signing Guide — Timestamp Screen Recorder

App ID (permanent): **`app.timestamprec.screen`**
Store title: **Timestamp Screen Recorder**

## 1. How signing works (Play App Signing)

Two different keys — do not confuse them:

| Key | Held by | Purpose |
|-----|---------|---------|
| **Upload key** — `android/upload-keystore.jks` | You | Signs the `.aab` *before upload*. Gradle uses it automatically via `android/key.properties`. |
| **App signing key** | Google | Google re-signs the APKs delivered to users. |

You upload an AAB signed with the **upload key**; Google re-signs it with the
**app signing key**. If the upload key is ever lost, you can reset it from the
Play Console — you never lose the ability to update the app.

Current upload-key fingerprint (SHA-256):
`72:6B:D8:15:26:7D:DB:8A:9F:CD:8A:8E:1B:BB:8F:52:93:C2:89:5B:4A:B2:59:65:F8:C9:02:91:D6:07:CC:1E`

Verify any build is signed with it:
```
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

## 2. Build the release bundle

```
flutter build appbundle --release
# Smaller + obfuscated Dart (recommended for production):
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```
Output: `build/app/outputs/bundle/release/app-release.aab`

> Keep the `build/symbols` folder to de-obfuscate crash stack traces later.

## 3. Upload to Play Console

1. **Create app** → name, default language, app type, free/paid.
2. **Release → Setup → App integrity**: leave **Play App Signing enabled** (default).
3. **Internal testing → Create release** → upload the `.aab`. The package name
   locks to `app.timestamprec.screen` on first upload.
4. Complete **Privacy Policy URL**, **Data safety**, **Content rating**, and the
   **Foreground service (mediaProjection)** declaration (see DATA_SAFETY.md).
5. Promote Internal → Closed/Open testing → Production.

## 4. Back up these — losing them loses update ability*

- `android/upload-keystore.jks`  (NEVER commit — git-ignored)
- `android/key.properties`        (NEVER commit — git-ignored; holds the
  store/key passwords locally only)

> The upload-key password lives only in your local `android/key.properties`,
> which is git-ignored and must never be published. If it is ever exposed,
> regenerate the keystore (below) and/or reset the upload key in Play Console.

\* With Play App Signing you *can* reset a lost upload key, but back it up anyway.

To regenerate the upload key with your own password:
```
keytool -genkeypair -v -keystore android/upload-keystore.jks -alias upload \
  -keyalg RSA -keysize 2048 -validity 10000
# then update android/key.properties with the new passwords
```

## 5. Bumping the version for each update

Edit `pubspec.yaml` → `version: 1.0.0+1`. The part after `+` is the
`versionCode` (must increase every upload); the part before is the
user-visible `versionName`. Example next update: `version: 1.0.1+2`.

## 6. Still required before review

- [ ] Privacy Policy hosted at a public URL (content in `store/PRIVACY_POLICY.md`)
- [ ] Data safety form filled (answers in `store/DATA_SAFETY.md`)
- [ ] Store listing text + screenshots (see `store/LISTING.md`)
- [ ] Content rating questionnaire (no sensitive content → expect Everyone)
- [ ] Foreground-service `mediaProjection` justification video/screens
