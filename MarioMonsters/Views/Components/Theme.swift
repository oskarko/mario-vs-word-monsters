import SwiftUI

enum Theme {
    static let background = Color(red: 0.98, green: 0.96, blue: 0.90)
    static let card = Color.white
    static let ink = Color(red: 0.16, green: 0.14, blue: 0.24)
    static let good = Color(red: 0.20, green: 0.72, blue: 0.40)
    static let bad = Color(red: 0.93, green: 0.33, blue: 0.30)
    static let neutral = Color(red: 0.36, green: 0.55, blue: 0.95)
    static let gold = Color(red: 1.00, green: 0.76, blue: 0.18)
    static let maxWidth: CGFloat = 720

    static func title(_ size: CGFloat = 30) -> Font { .system(size: size, weight: .heavy, design: .rounded) }
    static func body(_ size: CGFloat = 19) -> Font { .system(size: size, weight: .semibold, design: .rounded) }
}

extension MonsterID {
    var color: Color {
        switch self {
        case .ae: Color(red: 0.55, green: 0.36, blue: 0.95)
        case .noNo: Color(red: 0.95, green: 0.35, blue: 0.35)
        case .jumper: Color(red: 0.20, green: 0.70, blue: 0.85)
        case .snake: Color(red: 0.30, green: 0.75, blue: 0.35)
        case .traps: Color(red: 1.00, green: 0.58, blue: 0.20)
        case .gotLost: Color(red: 0.95, green: 0.45, blue: 0.70)
        default:
            // Movers packs: spread hues evenly so neighbours in the grid look different.
            Color(hue: (Double(index) * 0.137).truncatingRemainder(dividingBy: 1), saturation: 0.55, brightness: 0.88)
        }
    }

    var index: Int { MonsterID.allCases.firstIndex(of: self) ?? 0 }

    /// The original monsters have hand-made looks; the rest share generated ones plus their emblem.
    var isOriginal: Bool { [.ae, .noNo, .jumper, .snake, .traps].contains(self) }
}

/// Chunky "3D" button: the face sinks onto its shadow when pressed.
struct ChunkyButtonStyle: ButtonStyle {
    var color: Color = Theme.neutral
    var textColor: Color = .white
    var font: Font = Theme.body(21)

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(font)
            .foregroundStyle(textColor)
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
            .frame(minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(color)
                    .shadow(color: color.mix(with: .black, by: 0.35), radius: 0, y: pressed ? 1 : 5)
            )
            .offset(y: pressed ? 4 : 0)
            .animation(.spring(duration: 0.15), value: pressed)
    }
}

extension View {
    func cardStyle(padding: CGFloat = 18) -> some View {
        self
            .padding(padding)
            .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Theme.card))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }

    func readableWidth() -> some View {
        frame(maxWidth: Theme.maxWidth).frame(maxWidth: .infinity)
    }
}

struct SpeakButton: View {
    let action: () -> Void
    var systemImage = "speaker.wave.2.fill"
    var size: CGFloat = 54
    var color = Theme.neutral
    var label = "Escuchar"

    var body: some View {
        Button {
            Haptics.tap()
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.42, weight: .bold))
                .frame(width: size, height: size)
        }
        .buttonStyle(ChunkyButtonStyle(color: color))
        .accessibilityLabel(label)
    }
}

struct HealthBar: View {
    let value: Double
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.08))
                Capsule().fill(color)
                    .frame(width: max(0, proxy.size.width * value))
            }
        }
        .frame(height: 12)
        .animation(.spring, value: value)
    }
}
