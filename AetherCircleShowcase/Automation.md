# Showcase automation tour

From Home, choose **Automation**, then **Run Showcase Tour**.

The tour disables physical app interaction, returns Home for 10 seconds,
opens Primitive Objects for 10 seconds, returns Home, opens Panel Objects
for 10 seconds, returns Home, opens Materials for 10 seconds, then returns
Home for 5 seconds. It re-enables interaction and activates the normal Quit
button and its Yes confirmation. Total programmed wait time is 45 seconds.

The script is embedded in the shared Showcase application and runs through
the platform's `runTextScript` API. Navigation uses stable `autoID` values.
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
