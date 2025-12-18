import SwiftUI
import FlatSwitch

@main
struct FlatSwitchExampleApp: App {
    @State private var engineOn = false
    @State private var subengine1On = true
    @State private var subengine3On = false

    var body: some Scene {
        WindowGroup {
            ContentView(
                engineOn: $engineOn,
                subengine1On: $subengine1On,
                subengine3On: $subengine3On
            )
        }
    }
}
