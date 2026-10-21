# Showcase automation tours

The home menu fills four rows in its first column, then continues in its second:
Primitive Objects, Materials, Environment A, Environment B, Panel Objects, Automation.
The stable automation identifiers remain unchanged when the buttons move.

Automation contains two buttons, both using typed `AetherAutomationScript`
values and `platform.runScript`. Each button navigates to Home before starting
the runner. The script waits one second so Home appears before its first visit.
Physical interaction is disabled for the tour and automatically restored by
the runner on completion or failure. Both tours finish at Home; neither quits.

| Button | Visits | Programmed waits |
| --- | --- | --- |
| Tour Environments A + B | All 20 A choices, then available B choices, including stereo video | At most 51 seconds |
| Tour Primitives, Materials + Panels | Primitives, Materials, Panels and its control page | 42 seconds |

The environment tour holds each A choice for 1.2 seconds and each B choice for
1.6 seconds. Unavailable optional entries are omitted: missing embedded video,
unregistered images, and unsupported/unregistered Apple spatial photos. It
restores passthrough before returning Home. The maximum wait budget leaves
nine seconds for frame-driven navigation/command overhead under the 60-second
tour requirement during normal rendering.

The section tour holds Primitives and Materials for 12 seconds each, and each
Panel page for eight seconds. It checks the checkbox before and after toggling,
then checks that the integer advances from 4 to 5. Its 42-second wait budget
leaves 18 seconds for command overhead.

These replace the previous script/text-script/direct-command demonstration
buttons. Text scripts and invocable commands remain framework features; this
Showcase screen uses typed scripts only.

