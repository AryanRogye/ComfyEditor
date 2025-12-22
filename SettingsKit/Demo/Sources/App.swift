import SwiftUI
import SettingsKit

@main
struct SettingsKitDemoApp: App {
    @State private var settings = SettingsState()
//    @State private var stressTest = StressTestSettings()
    
    var body: some Scene {
        WindowGroup {
            DemoSettings()
                .environment(settings)
//            StressTestSettingsContainer(settings: stressTest)
        }
    }
}
