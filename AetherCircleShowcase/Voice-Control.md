# Showcase voice control

This project opts in with `voiceControl=true` in `AetherCircle.info`; other new
projects default to off unless initialized with `-voice` (or `--voice`).

Allow microphone access (and speech recognition on Apple Vision Pro), then say:

| Phrase | Destination |
| --- | --- |
| Showcase, home | Home |
| Showcase, primitive objects | Primitive Objects |
| Showcase, materials | Materials |
| Showcase, environment A | Environment A |
| Showcase, environment B | Environment B |
| Showcase, dialogs | Dialogs |
| Showcase, U I elements | UI Elements |
| Showcase, automation | Automation |

Speak U and I as separate letters. These commands are available throughout the
app and invoke the same actions as the main menu buttons. Alternatively, say
“Showcase,” then give the command within five seconds. Commands are suspended
while application interaction is disabled by an automation script.

AVP uses Apple speech recognition. Quest packages an offline English recognizer;
the first build downloads its roughly 40 MB model and first launch unpacks it.
Granting microphone permission is required once. Initial preparation and errors
appear in platform logs; Quest also displays a short readiness/error toast.

After pulling Examples and AetherCircleDevelopment, rebuild the development CLI
with `./Scripts/makeclitool.sh` in AetherCircleDevelopment. In this project directory:

```sh
aethercircle quest create --delete
aethercircle quest make
aethercircle quest install
aethercircle quest start
```

For AVP, update the AetherCircleDevelopment package to latest main and rebuild.
The checked-in Info.plist and XcodeGen configuration both include voice permissions.
Physical headset testing is required for microphone/wake phrase reliability.
