<div align="center">

# ⏱️ Timestamp Screen Recorder

**An Android screen recorder that burns a precise millisecond timestamp directly into every video.**

`yyyy-MM-dd HH:mm:ss.SSS` — visible across every screen, captured into the footage itself.

![Platform](https://img.shields.io/badge/platform-Android%208.0%2B-3DDC84?logo=android&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.32-02569B?logo=flutter&logoColor=white)
![Native](https://img.shields.io/badge/capture-Kotlin%20%2F%20MediaProjection-7F52FF?logo=kotlin&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue)

</div>

---

## Why this exists

Most screen recorders just capture the screen. **Timestamp Screen Recorder** adds an
always-visible clock — down to the millisecond — that is *burned into the recording*,
so timing is part of the footage and not metadata you have to trust.

That makes it useful for a specific, underserved audience:

- 🧪 **QA & mobile engineers** — measure UI latency, prove exactly *when* a bug happened
- 📊 **Reviewers & benchmarkers** — compare response times frame-accurately
- 🧾 **Time-stamped evidence** — tamper-evident screen proof
- 🎮 **Speedrunners / traders / lab capture** — precise, correlate-able timing

## ✨ Features

- **Millisecond timestamp overlay** captured into the video, across every app
- **5 formats:** `datetime (24h)`, `time (24h)`, `datetime (12h)`, `time (12h)`, **`Unix epoch (ms)`**
- **UTC mode** + suffix — ideal for correlating with server logs
- **Elapsed timer** (`+mm:ss.SSS` from record start)
- **FPS counter** — real frame rate sampled every second
- **Microphone narration** (optional) recorded into the video
- **Floating stop button** — draggable, stop from anywhere without leaving your app
- **Stop → return to app** action on the notification
- Timestamp **position** (6 placements), **font size**, **resolution** (30/50/75/100 %) and **bitrate**
- **Light / dark theme** following the system
- **8 languages:** English, Tiếng Việt, Français, 日本語, ไทย, 中文, Español, Deutsch
- No ads · no account · no tracking · **no internet access**

## 🧠 How the timestamp is burned in

The millisecond clock is **not** drawn by Flutter. It is a native
`TYPE_APPLICATION_OVERLAY` window updated every frame via `Choreographer`.
`MediaProjection` mirrors the *fully composited* display, so the overlay is
captured into the MP4 on top of whatever app is on screen. That's why the
"Display over other apps" permission is required in addition to the one-time
screen-capture consent.

```
Flutter UI  ──MethodChannel──►  MainActivity
                                    │  (consent + RECORD_AUDIO)
                                    ▼
                       ScreenRecordService  (foreground service)
                         ├─ MediaProjection → VirtualDisplay → MediaRecorder (H.264 / AAC → MP4)
                         ├─ TimestampOverlay   (clock • fps • elapsed)
                         └─ FloatingControls   (draggable stop pill)
                                    │
                                    ▼
                        RecordingStore → Movies/Timestamp (MediaStore)
```

## 🏗️ Tech stack

| Layer | Tech |
|------|------|
| UI | Flutter 3.32 / Dart 3.8, Material 3, `flutter_localizations` (gen-l10n) |
| Capture | Native Kotlin — `MediaProjection`, `VirtualDisplay`, `MediaRecorder` |
| Overlays | `WindowManager` system overlays (`TYPE_APPLICATION_OVERLAY`) |
| Storage | `MediaStore` (scoped storage, Android 10+) |

## 📁 Project structure

```
lib/
├── main.dart            # Home screen, settings, recordings list
├── recorder.dart        # MethodChannel wrapper + models (RecordConfig, RecStatus…)
├── widgets.dart         # AppLogo, LiveClock, PulsingDot, timestamp formatting
├── theme.dart           # Light/dark AppColors ThemeExtension
└── l10n/                # app_*.arb for 8 locales

android/app/src/main/kotlin/com/khanhpham/timestamp/
├── MainActivity.kt        # MethodChannel + consent + permission flow
├── ScreenRecordService.kt # Foreground capture pipeline + RecordConfig
├── TimestampOverlay.kt    # Millisecond clock / FPS / elapsed overlay
├── FloatingControls.kt    # Draggable stop button
└── RecordingStore.kt      # MediaStore persistence

store/                    # Play Store paperwork (privacy, data safety, listing, release)
```

## 🚀 Getting started

**Prerequisites:** Flutter 3.32+, Android SDK (API 26+), a device/emulator on Android 8.0+.

```bash
flutter pub get
flutter run                 # debug on a connected device
```

Build artifacts:

```bash
flutter build apk --debug                       # quick install APK
flutter build appbundle --release               # Play Store bundle (AAB)
flutter test                                    # unit/widget tests
flutter analyze                                 # static analysis
```

> Release builds are signed with an upload key configured in `android/key.properties`
> (git-ignored). See [`store/RELEASE.md`](store/RELEASE.md) for signing & publishing.

## 🔐 Permissions

| Permission | Purpose |
|-----------|---------|
| `FOREGROUND_SERVICE` / `…_MEDIA_PROJECTION` | Run the recorder reliably in the background |
| `SYSTEM_ALERT_WINDOW` | Draw the timestamp overlay / floating button into the capture |
| `RECORD_AUDIO` / `FOREGROUND_SERVICE_MICROPHONE` | Optional microphone narration |
| `POST_NOTIFICATIONS` | The ongoing recording notification (Android 13+) |

The Android system also shows its own **screen-recording indicator** while recording —
that is enforced by the OS for every app and cannot be removed.

## 🗺️ Roadmap

- [ ] Internal/device audio capture (`AudioPlaybackCapture` + `MediaCodec`)
- [ ] In-app trim/cut (`MediaExtractor` / `MediaMuxer`)
- [ ] In-app language & theme override (independent of system)

## 🛡️ Privacy

The app collects **nothing**. Recordings stay on your device unless you share them
yourself. Full policy: [`store/PRIVACY_POLICY.md`](store/PRIVACY_POLICY.md).

## 📦 Publishing

Application ID: `com.khanhpham.timestamp`. All Play Console material is in
[`store/`](store/) — privacy policy, data-safety answers, listing copy (ASO), and a
step-by-step signing/release guide.

## 📄 License

Released under the **MIT License** — see [`LICENSE`](LICENSE).
