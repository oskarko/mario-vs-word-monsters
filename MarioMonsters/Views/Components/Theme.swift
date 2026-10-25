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
        case .ae: Color(red: 0.38, green: 0.72, blue: 0.24) // verde campo, Mario's favourite
        case .noNo: Color(red: 0.95, green: 0.35, blue: 0.35)
        case .jumper: Color(red: 0.20, green: 0.70, blue: 0.85)
        case .snake: Color(red: 0.55, green: 0.36, blue: 0.95)
        case .traps: Color(red: 1.00, green: 0.58, blue: 0.20)
        case .gotLost: Color(red: 0.95, green: 0.45, blue: 0.70)
        // Movers packs: one distinct colour each, so no two monsters look alike.
        case .mixer: Color(red: 0.16, green: 0.66, blue: 0.62)
        case .yesterday: Color(red: 0.84, green: 0.64, blue: 0.16)
        case .bigger: Color(red: 0.48, green: 0.55, blue: 0.95)
        case .nowNow: Color(red: 1.00, green: 0.50, blue: 0.42)
        case .octopus: Color(red: 0.75, green: 0.55, blue: 0.90)
        case .apostrophe: Color(red: 0.80, green: 0.42, blue: 0.30)
        case .plurals: Color(red: 0.40, green: 0.72, blue: 0.98)
        case .bossy: Color(red: 0.85, green: 0.25, blue: 0.50)
        case .snail: Color(red: 0.55, green: 0.72, blue: 0.55)
        case .linker: Color(red: 1.00, green: 0.76, blue: 0.56)
        case .animals: Color(red: 0.78, green: 0.55, blue: 0.35)
        case .body: Color(red: 0.62, green: 0.36, blue: 0.62)
        case .clothes: Color(red: 0.45, green: 0.88, blue: 0.75)
        case .family: Color(red: 0.98, green: 0.86, blue: 0.36)
        case .food: Color(red: 0.98, green: 0.68, blue: 0.58)
        case .home: Color(red: 0.30, green: 0.42, blue: 0.78)
        case .school: Color(red: 0.62, green: 0.64, blue: 0.26)
        case .sports: Color(red: 0.88, green: 0.38, blue: 0.85)
        case .town: Color(red: 0.52, green: 0.60, blue: 0.70)
        case .nature: Color(red: 0.22, green: 0.56, blue: 0.36)
        case .transport: Color(red: 0.88, green: 0.78, blue: 0.60)
        case .time: Color(red: 0.42, green: 0.32, blue: 0.76)
        case .jobs: Color(red: 0.15, green: 0.52, blue: 0.86)
        case .numbers: Color(red: 0.12, green: 0.42, blue: 0.52)
        case .feelings: Color(red: 0.90, green: 0.66, blue: 0.96)
        case .twinTimes: Color(red: 0.95, green: 0.42, blue: 0.20)
        }
    }

    var index: Int { MonsterID.allCases.firstIndex(of: self) ?? 0 }
}

/// Chunky "3D" button: the face sinks onto its shadow when pressed.
struct ChunkyButtonStyle: ButtonStyle {
    var color: Color = Theme.neutral
    var textColor: Color = .white
    var font: Font = Theme.body(21)
    var horizontalPadding: CGFloat = 22

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        configuration.label
            .font(font)
            .foregroundStyle(textColor)
            .padding(.horizontal, horizontalPadding)
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
