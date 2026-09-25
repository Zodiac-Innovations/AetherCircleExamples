import SwiftUI
import AetherCircleCore
import AetherCircleAVP

@main
struct AetherCircleShowcaseAVPApp: App {

    var body: some Scene {
        AetherCircleAVPScenes { world in
            AetherCircleShowcaseApplication(
                world: world,
                name: "AetherCircle Showcase"
            )
        }
    }
}
