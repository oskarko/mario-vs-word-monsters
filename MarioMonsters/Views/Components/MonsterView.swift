import SwiftUI

enum MonsterMood: Equatable {
    case idle, hit, laugh, defeated
}

/// A friendly blob monster drawn with plain shapes (no image assets), one look per root error.
struct MonsterView: View {
    let monster: MonsterID
    var mood: MonsterMood = .idle
    var size: CGFloat = 120
    /// Changing this value replays the hit / laugh shake.
    var trigger: Int = 0

    @State private var breathing = false

    var body: some View {
        ZStack {
            features(behind: true)
            body(color: monster.color)
            face
            features(behind: false)
        }
        .frame(width: size, height: size)
        .scaleEffect(breathing ? 1.03 : 0.97, anchor: .bottom)
        .saturation(mood == .defeated ? 0.1 : 1)
        .opacity(mood == .defeated ? 0.6 : 1)
        .keyframeAnimator(initialValue: 0.0, trigger: trigger) { view, offset in
            view.offset(x: offset).rotationEffect(.degrees(offset / 2))
        } keyframes: { _ in
            KeyframeTrack {
                CubicKeyframe(-12, duration: 0.07)
                CubicKeyframe(12, duration: 0.09)
                CubicKeyframe(-8, duration: 0.09)
                CubicKeyframe(6, duration: 0.08)
                CubicKeyframe(0, duration: 0.1)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { breathing = true }
        }
        .accessibilityLabel(monster.info.name)
    }

    private var unit: CGFloat { size / 100 }

    private enum Feature { case horns, antennae, spikes, hat, none }

    private var eyeCount: Int {
        if monster == .ae { return 1 }
        if monster.isOriginal { return 2 }
        return [2, 3, 1][monster.index % 3]
    }

    private var feature: Feature {
        [.horns, .antennae, .spikes, .hat, .none][monster.index % 5]
    }

    private func body(color: Color) -> some View {
        Ellipse()
            .fill(
                LinearGradient(colors: [color.mix(with: .white, by: 0.25), color], startPoint: .top, endPoint: .bottom)
            )
            .overlay(Ellipse().stroke(color.mix(with: .black, by: 0.3), lineWidth: 3 * unit))
            .frame(width: 84 * unit, height: 76 * unit)
            .offset(y: 10 * unit)
    }

    private var face: some View {
        VStack(spacing: 6 * unit) {
            HStack(spacing: 10 * unit) {
                switch eyeCount {
                case 1: eye(width: 30)
                case 3: ForEach(0..<3, id: \.self) { _ in eye(width: 16) }
                default:
                    eye(width: 20)
                    eye(width: 20)
                }
            }
            mouth
        }
        .offset(y: 8 * unit)
    }

    private func eye(width: CGFloat) -> some View {
        ZStack {
            Circle().fill(.white)
            if mood == .defeated {
                Image(systemName: "xmark")
                    .font(.system(size: width * 0.5 * unit, weight: .black))
                    .foregroundStyle(Theme.ink)
            } else if mood == .hit {
                Capsule().fill(Theme.ink).frame(width: width * 0.6 * unit, height: 3 * unit)
            } else {
                Circle().fill(Theme.ink).frame(width: width * 0.45 * unit)
                    .offset(x: width * 0.1 * unit, y: mood == .laugh ? -width * 0.1 * unit : 0)
            }
        }
        .frame(width: width * unit, height: width * unit)
        .overlay(Circle().stroke(Theme.ink.opacity(0.6), lineWidth: 1.5 * unit))
    }

    @ViewBuilder
    private var mouth: some View {
        switch mood {
        case .laugh:
            HalfCircle()
                .fill(Theme.ink)
                .overlay(alignment: .top) { teeth }
                .frame(width: 36 * unit, height: 18 * unit)
        case .hit, .defeated:
            Ellipse().fill(Theme.ink).frame(width: 14 * unit, height: 16 * unit)
        case .idle:
            HalfCircle()
                .fill(Theme.ink)
                .overlay(alignment: .top) { teeth }
                .frame(width: 28 * unit, height: 12 * unit)
        }
    }

    private var teeth: some View {
        HStack(spacing: 8 * unit) {
            Triangle().fill(.white).frame(width: 6 * unit, height: 6 * unit).rotationEffect(.degrees(180))
            Triangle().fill(.white).frame(width: 6 * unit, height: 6 * unit).rotationEffect(.degrees(180))
        }
    }

    @ViewBuilder
    private func features(behind: Bool) -> some View {
        let dark = monster.color.mix(with: .black, by: 0.3)
        switch monster {
        case .ae where behind:
            ForEach(0..<5) { index in
                Triangle()
                    .fill(dark)
                    .frame(width: 16 * unit, height: 20 * unit)
                    .offset(y: -38 * unit)
                    .rotationEffect(.degrees(Double(index - 2) * 28))
                    .offset(y: 10 * unit)
            }
        case .noNo where behind:
            ForEach([-1.0, 1.0], id: \.self) { side in
                Triangle()
                    .fill(Theme.ink)
                    .frame(width: 14 * unit, height: 26 * unit)
                    .rotationEffect(.degrees(side * 20))
                    .offset(x: side * 26 * unit, y: -30 * unit)
            }
        case .jumper where behind:
            ForEach([-1.0, 1.0], id: \.self) { side in
                VStack(spacing: 0) {
                    Circle().fill(Theme.gold).frame(width: 12 * unit)
                    Rectangle().fill(dark).frame(width: 3 * unit, height: 22 * unit)
                }
                .rotationEffect(.degrees(side * 18))
                .offset(x: side * 18 * unit, y: -36 * unit)
            }
        case .snake where !behind:
            Capsule()
                .fill(Theme.bad)
                .frame(width: 5 * unit, height: 16 * unit)
                .offset(y: 38 * unit)
                .opacity(mood == .laugh ? 1 : 0)
        case .traps where !behind:
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3 * unit).fill(Theme.ink).frame(width: 26 * unit, height: 22 * unit)
                Capsule().fill(Theme.ink).frame(width: 44 * unit, height: 6 * unit)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.bad).frame(width: 26 * unit, height: 4 * unit).offset(y: -6 * unit)
            }
            .rotationEffect(.degrees(-12))
            .offset(x: 10 * unit, y: -30 * unit)
        case _ where monster.isOriginal:
            EmptyView()
        default:
            generated(behind: behind, dark: dark)
        }
    }

    @ViewBuilder
    private func generated(behind: Bool, dark: Color) -> some View {
        if behind {
            switch feature {
            case .horns:
                ForEach([-1.0, 1.0], id: \.self) { side in
                    Triangle()
                        .fill(dark)
                        .frame(width: 12 * unit, height: 22 * unit)
                        .rotationEffect(.degrees(side * 25))
                        .offset(x: side * 24 * unit, y: -30 * unit)
                }
            case .antennae:
                ForEach([-1.0, 1.0], id: \.self) { side in
                    VStack(spacing: 0) {
                        Circle().fill(monster.color.mix(with: .white, by: 0.5)).frame(width: 10 * unit)
                        Rectangle().fill(dark).frame(width: 3 * unit, height: 20 * unit)
                    }
                    .rotationEffect(.degrees(side * 25))
                    .offset(x: side * 20 * unit, y: -34 * unit)
                }
            case .spikes:
                ForEach(0..<3) { index in
                    Triangle()
                        .fill(dark)
                        .frame(width: 14 * unit, height: 16 * unit)
                        .offset(y: -36 * unit)
                        .rotationEffect(.degrees(Double(index - 1) * 30))
                        .offset(y: 10 * unit)
                }
            case .hat, .none:
                EmptyView()
            }
        } else {
            ZStack {
                if feature == .hat {
                    VStack(spacing: 0) {
                        Capsule().fill(dark).frame(width: 30 * unit, height: 14 * unit)
                        Capsule().fill(dark).frame(width: 46 * unit, height: 5 * unit)
                    }
                    .offset(y: -30 * unit)
                }
                Text(monster.info.emblem)
                    .font(.system(size: 13 * unit, weight: .black, design: .rounded))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 5 * unit)
                    .frame(minWidth: 26 * unit, minHeight: 26 * unit)
                    .background(Capsule().fill(.white))
                    .overlay(Capsule().stroke(dark, lineWidth: 2 * unit))
                    .offset(x: 34 * unit, y: -26 * unit)
            }
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

private struct HalfCircle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.maxY * 2))
            path.closeSubpath()
        }
    }
}

#Preview {
    HStack {
        ForEach(MonsterID.allCases) { MonsterView(monster: $0, size: 70) }
    }
}
