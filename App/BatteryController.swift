import ActivityKit
import Combine
import UIKit

@MainActor
final class BatteryController: ObservableObject {
    @Published private(set) var state = XenoAttributes.ContentState(level: 0, charging: false, measuredAt: .now, demo: false)
    @Published private(set) var running = false
    @Published private(set) var busy = false
    @Published var message: String?
    private var subscriptions = Set<AnyCancellable>()
    private var watcher: Task<Void, Never>?

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        readBattery()
        running = !liveActivities.isEmpty
        if let activity = liveActivities.first { watch(activity) }
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification),
            NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)
        ).receive(on: RunLoop.main).sink { [weak self] _ in
            Task { @MainActor [weak self] in await self?.refresh() }
        }.store(in: &subscriptions)
        Timer.publish(every: 30, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard UIApplication.shared.applicationState == .active else { return }
            Task { @MainActor [weak self] in await self?.refresh() }
        }.store(in: &subscriptions)
    }

    private var liveActivities: [Activity<XenoAttributes>] {
        Activity<XenoAttributes>.activities.filter { $0.activityState == .active || $0.activityState == .stale }
    }

    private func readBattery() {
        let device = UIDevice.current
        let level = device.batteryLevel
        guard level >= 0 else {
            message = "Batterie indisponible ici. Utilise un iPhone réel, ou les poses de démonstration."
            return
        }
        state = .init(level: min(100, max(0, Int((level * 100).rounded()))),
                      charging: device.batteryState == .charging || device.batteryState == .full,
                      measuredAt: .now, demo: false)
    }

    private func watch(_ activity: Activity<XenoAttributes>) {
        watcher?.cancel()
        watcher = Task { [weak self] in
            for await status in activity.activityStateUpdates {
                guard !Task.isCancelled else { return }
                if status == .ended || status == .dismissed {
                    self?.running = false
                }
            }
        }
    }

    private var content: ActivityContent<XenoAttributes.ContentState> {
        ActivityContent(state: state, staleDate: .now.addingTimeInterval(300))
    }

    func start() async {
        guard !busy else { return }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            message = "Les activités en direct sont désactivées. Autorise-les dans les réglages de l’iPhone pour Xéno Batterie."
            return
        }
        busy = true
        defer { busy = false }
        message = nil
        readBattery()
        do {
            if let existing = liveActivities.first {
                await existing.update(content)
                for duplicate in liveActivities.dropFirst() {
                    await duplicate.end(nil, dismissalPolicy: .immediate)
                }
                running = true
                watch(existing)
            } else {
                let activity = try Activity.request(attributes: XenoAttributes(), content: content, pushType: nil)
                running = true
                watch(activity)
            }
        } catch {
            message = "Impossible de démarrer : \(error.localizedDescription)"
        }
    }

    func refresh() async {
        guard !busy else { return }
        busy = true
        defer { busy = false }
        readBattery()
        let activities = liveActivities
        running = !activities.isEmpty
        for activity in activities { await activity.update(content) }
    }

    func demo(_ level: Int) async {
        guard !busy else { return }
        busy = true
        defer { busy = false }
        state = .init(level: level, charging: true, measuredAt: .now, demo: true)
        for activity in liveActivities { await activity.update(content) }
    }

    func stop() async {
        guard !busy else { return }
        busy = true
        defer { busy = false }
        watcher?.cancel()
        for activity in Activity<XenoAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        running = false
    }
}
