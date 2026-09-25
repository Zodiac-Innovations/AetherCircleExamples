import SwiftUI
import AetherCircleCore
import AetherCircleAVP

@main
struct ShowcaseAVPApp: App {

    var body: some Scene {
        AetherCircleAVPScenes { world in
            ShowcaseApplication(
                world: world,
                name: "Showcase"
            )
        }
    }
}
