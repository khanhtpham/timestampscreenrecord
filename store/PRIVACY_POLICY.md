# Privacy Policy — Timestamp Screen Recorder

_Last updated: 2 June 2026_

Timestamp Screen Recorder ("the app", package `com.khanhpham.timestamp`) is a
screen-recording tool that overlays a millisecond timestamp onto the recording.
This policy explains what the app does and does not do with your information.

## Summary

**The app does not collect, transmit, or share any personal data.** It has no
account system, no analytics, no advertising, and makes no network connections.
Everything happens on your device.

## What the app accesses

- **Screen capture (MediaProjection):** Used only while you are recording, and
  only after you grant the system "Start recording" consent each session. The
  captured video is encoded on-device and saved as an MP4 file.
- **Display over other apps (overlay):** Used to draw the millisecond timestamp
  on top of the screen so it appears in the recording. The overlay only renders
  the current date and time.
- **Notifications:** A persistent notification is shown while recording, as
  required by Android for foreground services.

## Where recordings are stored

Recordings are saved locally to your device's **Movies/Timestamp**
folder (via the Android MediaStore). They never leave your device unless **you**
choose to share or move them using other apps. You can delete any recording from
within the app at any time.

## Data sharing

None. The app contains no third-party SDKs, trackers, or ad networks, and sends
no data to any server (including the developer).

## Children's privacy

The app collects no data from anyone, including children.

## Permissions reference

| Permission | Why |
|-----------|-----|
| `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PROJECTION` | Run the recorder reliably while you use other apps. |
| `SYSTEM_ALERT_WINDOW` | Draw the timestamp overlay that gets captured into the video. |
| `POST_NOTIFICATIONS` | Show the ongoing "recording" notification (Android 13+). |
| `RECORD_AUDIO`, `FOREGROUND_SERVICE_MICROPHONE` | Optional: record microphone narration into the video. Used only when you enable it; the audio is written into your local MP4 and never sent anywhere. |

## Changes

Any future changes to this policy will be posted at this URL with an updated
date above.

## Contact

Questions: **phamtankhanh@gmail.com**
