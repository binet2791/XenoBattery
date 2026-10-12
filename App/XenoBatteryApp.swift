import SwiftUI

@main
struct XenoBatteryApp: App {
    @StateObject private var model = BatteryController()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
                .preferredColorScheme(.dark)
                .onOpenURL { _ in Task { await model.refresh() } }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        Task { await model.refresh() }
                    }
                }
        }
    }
}
