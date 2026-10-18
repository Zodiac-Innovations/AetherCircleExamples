# Showcase automation tour

From Home, choose **Automation**, then choose **Run Script Object**, **Run Text Script**, or **Run Command Objects**.

The tour disables physical app interaction, returns Home for 10 seconds,
opens Primitive Objects for 10 seconds, returns Home, opens Panel Objects
for 10 seconds (five per page), returns Home, opens Materials for 10 seconds, then returns
Home for 5 seconds. It re-enables interaction and activates the normal Quit
button and its Yes confirmation. Total programmed wait time is 45 seconds.

The shared application demonstrates a typed script through `runScript`, text
through `runTextScript`, and individual wait/tap/interaction objects through
synchronous `invoke()` calls on a Dispatch worker queue. All three run the same
sequence; direct waits leave rendering active by blocking only the worker. Navigation uses stable `autoID` values.
No scene registry is required. If the sequence fails, the error is printed
to the app log and the app requests that interaction be restored.

The project explicitly uses AetherCircleDevelopment/main, matching its AVP
package dependency. Its checked-in Quest Core snapshot, bootstrap, native
input adapter, and shared application have been updated together.

After pulling AetherCircleDevelopment and AetherCircleExamples, update the
AetherCircle Swift package in Xcode before building AVP. For Quest, rebuild
the updated project; if regenerating, keep the repo and branch entries in
AetherCircle.info so generation uses the automation-enabled framework.

Source checks verify command order, wait totals, navigation identifiers, and
snapshot hashes. Swift/Xcode and device execution still need testing.

Scripts now default to `turnsOffInteraction: true`, restoring interaction even
on failure or host stop. `AetherAutomationScript.make(text:turnsOffInteraction:)`
parses reusable text, and `runTextScript` uses that factory before `runScript`.
The `message "text"` command forwards a HUD banner request; the current dummy
HUD does not draw it yet. Direct command invocations preserve explicit input
management by using `turnsOffInteraction: false`.

Automation checks are available with `check tag 5 true` or another tap selector.
Scene lookup and taps now use `findObject`, `tapObject`, and `objectValue`.
Boolean controls expose "true"/"false", integer controls expose their current
numeric string, and other elements expose an empty string. Failed checks stop
the script, request a HUD failure banner, and run automatic input cleanup.

All three tour implementations now send progress messages with `message` and
run five value checks on the second Panel Objects page:

- Checkbox starts as "true", changes to "false" after a tap, then back to "true".
- Integer control starts as "4" and advances to "5" after a tap.

The tour requests an "All control checks passed" HUD message only after those
checks succeed. A failed check stops the tour before Materials or Quit. The
current dummy HUD does not render messages yet, but the commands still execute.
