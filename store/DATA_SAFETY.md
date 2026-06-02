# Play Console — Data Safety & Declarations

Copy these answers into the Play Console forms.

## Data safety form

- **Does your app collect or share any of the required user data types?** → **No.**
  - No data is collected. No data is shared. The app makes no network requests.
- **Is all of the user data encrypted in transit?** → N/A (no data leaves the device).
- **Do you provide a way for users to request that their data is deleted?** → N/A
  (no data collected; recordings are local files the user can delete in-app).

> Result: the store listing will show "No data shared with third parties" and
> "No data collected".

## Foreground service declaration

Play requires declaring each foreground-service type and justifying it.

- **Types:** `mediaProjection`, and `microphone` (only when the user enables
  microphone recording).
- **Justification:** "The app records the device screen to a local video file at
  the user's request. Recording runs as a foreground service so it continues
  reliably while the user navigates other apps, with a persistent notification
  and a Stop action visible the whole time. Capture only begins after the user
  grants the system screen-capture consent dialog. If the user turns on the
  optional microphone setting, the `microphone` type is added so their narration
  is recorded into the same local video; the mic is never used otherwise."
- **Demo:** record a short screen capture showing: open app → tap Start → system
  consent dialog → recording notification with Stop → stop returns to app.

## Permissions justification (if asked)

- `SYSTEM_ALERT_WINDOW`: draw the millisecond timestamp overlay so it is captured
  into the recording across all screens. Core, user-facing feature; optional
  (recording still works without it, just without the timestamp).
- `POST_NOTIFICATIONS`: required to show the ongoing recording notification.
- `RECORD_AUDIO`: optional microphone narration written into the local video.
  Requested at runtime only when the user enables the "Record microphone"
  setting; no audio is collected or transmitted off-device.

## Content rating

- No violence, sexual content, profanity, gambling, or user-generated content
  sharing. Expected rating: **Everyone / PEGI 3.**

## Target audience

- Not directed at children. Target age 13+ (utility/tools app).
