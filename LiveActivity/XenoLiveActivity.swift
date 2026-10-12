import ActivityKit
import WidgetKit
import SwiftUI

@main
struct XenoWidgetBundle: WidgetBundle {
    var body: some Widget { XenoLiveActivity() }
}

struct XenoLiveActivity: Widget {
    private let acid = Color(red: 0.65, green: 0.96, blue: 0.25)

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: XenoAttributes.self) { context in
            HStack(spacing: 16) {
                XenoView(pose: context.state.pose).frame(width: 82, height: 82)
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.demo ? "XÉNO · DÉMO" : "XÉNO BATTERIE").font(.caption.monospaced()).foregroundStyle(acid)
                    Text("\(context.state.level) %").font(.system(size: 32, weight: .semibold, design: .rounded)).contentTransition(.numericText())
                    Text(context.isStale ? "Mesure à actualiser" : context.state.caption).font(.caption)
                    Text("Mesuré à \(context.state.measuredAt.formatted(date: .omitted, time: .shortened))").font(.caption2).foregroundStyle(.gray)
                }
                Spacer(minLength: 0)
                Image(systemName: context.state.charging ? "bolt.fill" : "battery.75percent").foregroundStyle(acid)
            }.padding(16)
                .foregroundStyle(.white)
                .activityBackgroundTint(Color(red: 0.025, green: 0.035, blue: 0.04))
                .activitySystemActionForegroundColor(acid)
                .widgetURL(URL(string: "xenobattery://refresh"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    XenoView(pose: context.state.pose).frame(width: 64, height: 64)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(context.state.level) %").font(.title2.monospacedDigit()).contentTransition(.numericText())
                        Label(context.state.caption, systemImage: context.state.charging ? "bolt.fill" : "battery.75percent").font(.caption2).foregroundStyle(acid)
                    }.padding(.top, 8)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.isStale ? "Mesure à actualiser" : "Mesuré à \(context.state.measuredAt.formatted(date: .omitted, time: .shortened))")
                        Spacer()
                        Text("Ouvrir ↗").foregroundStyle(acid)
                    }.font(.caption2).padding(.top, 4)
                }
            } compactLeading: {
                // Le pourcentage à gauche de l'îlot…
                Text(context.state.demo ? "D·\(context.state.level)" : "\(context.state.level)%")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(context.isStale ? Color.gray : acid)
                    .contentTransition(.numericText())
            } compactTrailing: {
                // …et le xénomorphe à droite, le plus près possible de l'icône de batterie.
                XenoView(pose: context.state.pose).frame(width: 24, height: 24)
            } minimal: {
                XenoView(pose: context.state.pose).frame(width: 22, height: 22)
            }
            .keylineTint(acid)
            .widgetURL(URL(string: "xenobattery://refresh"))
        }
    }
}
