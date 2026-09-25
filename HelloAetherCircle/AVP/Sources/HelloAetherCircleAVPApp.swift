import SwiftUI
import AetherCircleCore
import AetherCircleAVP

@main
struct HelloAetherCircleAVPApp: App {

    var body: some Scene {
        AetherCircleAVPScenes { world in
            HelloAetherCircleApplication(
                world: world,
                name: "HelloAetherCircle"
            )
        }
    }
}
