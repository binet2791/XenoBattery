import ActivityKit
import Foundation

struct XenoAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var level: Int
        var charging: Bool
        var measuredAt: Date
        var demo: Bool

        var pose: Int {
            if level <= 20 { return 0 }
            if level < 80 { return 1 }
            if level < 100 { return 2 }
            return 3
        }

        var caption: String {
            if demo { return "Démonstration" }
            return charging ? "En charge" : "Sur batterie"
        }
    }
    var name: String = "Xéno"
}
