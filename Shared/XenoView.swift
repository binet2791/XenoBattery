import SwiftUI

// Original vector drawing: no external asset or dependency.
struct XenoView: View {
    var pose: Int
    var body: some View {
        Canvas { context, size in
            context.scaleBy(x: size.width / 100, y: size.height / 100)
            let ink = Color(red: 0.18, green: 0.21, blue: 0.23)
            let rim = Color(red: 0.53, green: 0.61, blue: 0.62)
            let acid = Color(red: 0.65, green: 0.96, blue: 0.25)
            func line(_ points: [CGPoint], color: Color, width: CGFloat) {
                var p = Path()
                if let first = points.first { p.move(to: first) }
                for point in points.dropFirst() { p.addLine(to: point) }
                context.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            }
            var tail = Path()
            tail.move(to: CGPoint(x: 51, y: 72))
            tail.addCurve(to: CGPoint(x: 91, y: pose == 0 ? 81 : 46), control1: CGPoint(x: 92, y: 108), control2: CGPoint(x: 98, y: 80))
            context.stroke(tail, with: .color(rim), style: StrokeStyle(lineWidth: 6, lineCap: .round))
            context.stroke(tail, with: .color(ink), style: StrokeStyle(lineWidth: 3, lineCap: .round))
            var tip = Path()
            tip.move(to: CGPoint(x: 91, y: pose == 0 ? 81 : 46))
            tip.addLine(to: CGPoint(x: 86, y: pose == 0 ? 72 : 36))
            tip.addLine(to: CGPoint(x: 97, y: pose == 0 ? 75 : 38))
            tip.closeSubpath()
            context.fill(tip, with: .color(rim))
            for y in [45, 52, 59] {
                line([CGPoint(x: 53, y: y), CGPoint(x: 70, y: y - 9), CGPoint(x: 73, y: y - 1)], color: rim, width: 4)
            }
            line([CGPoint(x: 45, y: 66), CGPoint(x: 33, y: 80), CGPoint(x: 37, y: 90), CGPoint(x: 26, y: 91)], color: rim, width: 8)
            line([CGPoint(x: 53, y: 69), CGPoint(x: 62, y: 83), CGPoint(x: 57, y: 92), CGPoint(x: 68, y: 93)], color: rim, width: 8)
            context.fill(Path(ellipseIn: CGRect(x: 36, y: 40, width: 26, height: 36)), with: .color(ink))
            for y in stride(from: 48, through: 66, by: 6) {
                line([CGPoint(x: 39, y: y), CGPoint(x: 49, y: y + 3), CGPoint(x: 59, y: y)], color: rim, width: 2)
            }
            let reach = pose >= 2
            line([CGPoint(x: 39, y: 45), CGPoint(x: 24, y: reach ? 33 : 55), CGPoint(x: 14, y: reach ? 17 : 47)], color: rim, width: 6)
            line([CGPoint(x: 57, y: 45), CGPoint(x: 73, y: reach ? 30 : 57), CGPoint(x: 79, y: reach ? 16 : 50)], color: rim, width: 6)
            for dx in [-4, 0, 4] {
                line([CGPoint(x: 14 + dx, y: reach ? 17 : 47), CGPoint(x: 12 + dx, y: reach ? 12 : 42)], color: rim, width: 1.7)
                line([CGPoint(x: 79 + dx, y: reach ? 16 : 50), CGPoint(x: 80 + dx, y: reach ? 10 : 44)], color: rim, width: 1.7)
            }
            // Long, eyeless dome and exposed jaws identify the tiny xenomorph.
            var dome = Path()
            dome.move(to: CGPoint(x: 24, y: 33))
            dome.addCurve(to: CGPoint(x: 79, y: 18), control1: CGPoint(x: 1, y: 9), control2: CGPoint(x: 74, y: -7))
            dome.addCurve(to: CGPoint(x: 57, y: 37), control1: CGPoint(x: 86, y: 31), control2: CGPoint(x: 70, y: 39))
            dome.closeSubpath()
            context.fill(dome, with: .linearGradient(Gradient(colors: [rim, ink, .black]), startPoint: CGPoint(x: 40, y: 4), endPoint: CGPoint(x: 45, y: 38)))
            context.stroke(dome, with: .color(rim), lineWidth: 1.5)
            line([CGPoint(x: 26, y: 16), CGPoint(x: 42, y: 10), CGPoint(x: 62, y: 11)], color: .white.opacity(0.55), width: 2)
            context.fill(Path(roundedRect: CGRect(x: 27, y: 31, width: 26, height: pose == 3 ? 12 : 7), cornerRadius: 3), with: .color(.black))
            for x in stride(from: 30, through: 49, by: 4) {
                line([CGPoint(x: x, y: 32), CGPoint(x: x, y: 35)], color: .white, width: 2)
            }
            if pose == 3 {
                line([CGPoint(x: 37, y: 38), CGPoint(x: 19, y: 41)], color: rim, width: 4)
                line([CGPoint(x: 20, y: 40), CGPoint(x: 16, y: 40)], color: .white, width: 2)
                context.fill(Path(ellipseIn: CGRect(x: 16, y: 46, width: 3, height: 6)), with: .color(acid))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .rotationEffect(.degrees(pose == 0 ? 13 : 0))
        .accessibilityLabel("Xénomorphe, pose \(pose + 1)")
    }
}
