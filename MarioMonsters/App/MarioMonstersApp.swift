import SwiftData
import SwiftUI

@main
struct MarioMonstersApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .tint(Theme.neutral)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [CardProgress.self, AttemptLog.self, SessionLog.self])
    }
}
