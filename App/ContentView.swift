import SwiftUI

struct ContentView: View {
    @ObservedObject var model: BatteryController
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breathe = false
    private let acid = Color(red: 0.65, green: 0.96, blue: 0.25)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("XÉNO BATTERIE").font(.caption.monospaced()).tracking(5).foregroundStyle(acid)
                XenoView(pose: model.state.pose)
                    .frame(width: 220, height: 220)
                    .offset(y: breathe ? -5 : 5)
                    .animation(reduceMotion ? nil : .easeInOut(duration: 2).repeatForever(autoreverses: true), value: breathe)
                    .onAppear { breathe = true }
                VStack(spacing: 8) {
                    Text("\(model.state.level) %").font(.system(size: 60, weight: .light, design: .rounded)).contentTransition(.numericText())
                    Label(model.state.caption, systemImage: model.state.charging ? "bolt.fill" : "battery.75percent")
                        .foregroundStyle(acid)
                    Text("Mesuré à \(model.state.measuredAt.formatted(date: .omitted, time: .shortened))")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Button(model.running ? "Actualiser la batterie" : "Afficher mon xénomorphe") {
                    Task { if model.running { await model.refresh() } else { await model.start() } }
                }.buttonStyle(.borderedProminent).tint(acid).foregroundStyle(.black).disabled(model.busy)
                if model.running {
                    Text("Retourne à l’accueil pour voir la Dynamic Island. Maintiens-la pour agrandir. Verrouille l’iPhone pour voir la carte.")
                        .font(.callout).foregroundStyle(.secondary)
                    Button("Retirer le xénomorphe", role: .destructive) { Task { await model.stop() } }
                        .disabled(model.busy)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Essayer les quatre poses").font(.headline)
                    HStack {
                        ForEach([10, 50, 90, 100], id: \.self) { level in
                            Button("\(level) %") { Task { await model.demo(level) } }
                                .buttonStyle(.bordered).disabled(model.busy)
                        }
                    }
                    Text("Ces valeurs sont fictives. Le retour dans l’app ou la prochaine mesure rétablit la vraie batterie.")
                        .font(.caption).foregroundStyle(.secondary)
                }.padding().background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 20))
                Text("Dans la Dynamic Island, les poses changent lors des mises à jour. La mesure peut vieillir lorsque l’app est suspendue; touche la carte pour revenir ici et l’actualiser. La respiration en boucle est visible dans cette app seulement.")
                    .font(.footnote).foregroundStyle(.secondary)
                if let message = model.message {
                    Text(message).foregroundStyle(.orange).font(.callout).accessibilityAddTraits(.updatesFrequently)
                }
            }.padding(24)
        }.background(Color(red: 0.025, green: 0.035, blue: 0.04))
    }
}
