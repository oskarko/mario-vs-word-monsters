import SwiftUI

enum MonsterMood: Equatable {
    case idle, hit, laugh, defeated
}

/// A friendly, slightly furry monster drawn with plain shapes (no image assets), so moods can animate.
/// Every monster combines a body, ears, eyes and mouth into its own look, plus its own colour.
struct MonsterView: View {
    let monster: MonsterID
    var mood: MonsterMood = .idle
    var size: CGFloat = 120
    /// Changing this value replays the hit / laugh shake.
    var trigger: Int = 0

    @State private var breathing = false

    var body: some View {
        ZStack {
            behindBody
            monsterBody
            belly
            face
            front
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

    // MARK: - Geometry (a 100 × 100 grid centred on the view)

    private var look: MonsterLook { MonsterLook.of(monster) }
    private var unit: CGFloat { size / 100 }
    private var color: Color { monster.color }
    private var light: Color { color.mix(with: .white, by: 0.3) }
    private var dark: Color { color.mix(with: .black, by: 0.28) }
    private var outline: Color { color.mix(with: .black, by: 0.4) }

    private var bodySize: CGSize {
        switch look.shape {
        case .tall: CGSize(width: 60, height: 70)
        case .round: CGSize(width: 70, height: 62)
        case .pear: CGSize(width: 66, height: 66)
        }
    }
    /// Every body stands on the same ground line.
    private var bodyCenterY: CGFloat { 37 - bodySize.height / 2 }
    private var bodyTop: CGFloat { 37 - bodySize.height }
    private var eyeY: CGFloat { bodyTop + bodySize.height * 0.26 }
    private var eyeSize: CGFloat { [1: 28, 3: 15][look.eyes] ?? 19 }
    private var mouthY: CGFloat { eyeY + eyeSize / 2 + 6 }

    private func at(_ x: CGFloat, _ y: CGFloat) -> CGSize { CGSize(width: x * unit, height: y * unit) }

    // MARK: - Body

    @ViewBuilder
    private var behindBody: some View {
        ears
        if look.tuft { tuft }
        if look.furry { fur }
        legs
        arms
    }

    private var monsterBody: some View {
        let width = bodySize.width, height = bodySize.height
        let bottom = width * (look.shape == .pear ? 0.3 : 0.22) * unit
        let shape = UnevenRoundedRectangle(
            topLeadingRadius: width * 0.48 * unit,
            bottomLeadingRadius: bottom,
            bottomTrailingRadius: bottom,
            topTrailingRadius: width * 0.48 * unit
        )
        return shape
            .fill(LinearGradient(colors: [light, color], startPoint: .top, endPoint: .bottom))
            .overlay(shape.stroke(outline, lineWidth: 2 * unit))
            .frame(width: width * unit, height: height * unit)
            .offset(at(0, bodyCenterY))
    }

    private var belly: some View {
        ZStack {
            Ellipse().fill(color.mix(with: .white, by: 0.45))
            if !monster.isOriginal {
                Text(monster.info.emblem)
                    .font(.system(size: 16 * unit, weight: .black, design: .rounded))
                    .foregroundStyle(Theme.ink.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .padding(.horizontal, 4 * unit)
            }
        }
        .frame(width: bodySize.width * 0.6 * unit, height: bodySize.height * 0.29 * unit)
        .offset(at(0, bodyCenterY + bodySize.height * 0.3))
    }

    private var legs: some View {
        ForEach([-1.0, 1.0], id: \.self) { side in
            VStack(spacing: -3 * unit) {
                Rectangle().fill(dark).frame(width: 12 * unit, height: 10 * unit)
                Capsule().fill(dark).frame(width: 19 * unit, height: 8 * unit)
                    .overlay(Capsule().stroke(outline, lineWidth: 1.5 * unit))
            }
            .offset(at(side * bodySize.width * 0.2, 42))
        }
    }

    private var arms: some View {
        ForEach([-1.0, 1.0], id: \.self) { side in
            Capsule()
                .fill(color)
                .overlay(Capsule().stroke(outline, lineWidth: 1.5 * unit))
                .frame(width: 11 * unit, height: 26 * unit)
                .rotationEffect(.degrees(side * (mood == .laugh ? -35 : 12)))
                .offset(at(side * (bodySize.width / 2 - 1), bodyCenterY + 8))
        }
    }

    /// Little tufts of fur sticking out of the sides.
    private var fur: some View {
        ForEach([-1.0, 1.0], id: \.self) { side in
            ForEach(0..<4) { index in
                Triangle()
                    .fill(color)
                    .frame(width: 9 * unit, height: 9 * unit)
                    .rotationEffect(.degrees(side * 90))
                    .offset(at(side * (bodySize.width / 2 + 1),
                               bodyCenterY - bodySize.height * 0.12 + CGFloat(index) * bodySize.height * 0.15))
            }
        }
    }

    private var tuft: some View {
        ForEach([-1.0, 0.0, 1.0], id: \.self) { side in
            Ellipse()
                .fill(light)
                .frame(width: 6 * unit, height: 14 * unit)
                .rotationEffect(.degrees(side * 28))
                .offset(at(side * 4, bodyTop - 2))
        }
    }

    // MARK: - Ears and horns

    @ViewBuilder
    private var ears: some View {
        let x = bodySize.width * 0.34
        switch look.ears {
        case .horns:
            ForEach([-1.0, 1.0], id: \.self) { side in
                Horn()
                    .fill(look.hornColor ?? Color(red: 0.47, green: 0.32, blue: 0.24))
                    .frame(width: 12 * unit, height: 20 * unit)
                    .scaleEffect(x: side, y: 1)
                    .offset(at(side * (x + 3), bodyTop + 2))
            }
        case .bunny:
            ForEach([-1.0, 1.0], id: \.self) { side in
                ZStack {
                    Ellipse().fill(color).overlay(Ellipse().stroke(outline, lineWidth: 1.5 * unit))
                    Ellipse().fill(Color(red: 1, green: 0.75, blue: 0.8)).padding(4 * unit)
                }
                .frame(width: 14 * unit, height: 26 * unit)
                .rotationEffect(.degrees(side * 22))
                .offset(at(side * x, bodyTop + 1))
            }
        case .elf:
            ForEach([-1.0, 1.0], id: \.self) { side in
                ZStack {
                    Triangle().fill(color).overlay(Triangle().stroke(outline, lineWidth: 1.5 * unit))
                    Triangle().fill(color.mix(with: .white, by: 0.45)).padding(5 * unit)
                }
                .frame(width: 20 * unit, height: 24 * unit)
                .rotationEffect(.degrees(side * 65))
                .offset(at(side * (bodySize.width / 2 + 4), eyeY - 4))
            }
        case .round:
            ForEach([-1.0, 1.0], id: \.self) { side in
                ZStack {
                    Circle().fill(color).overlay(Circle().stroke(outline, lineWidth: 1.5 * unit))
                    Circle().fill(color.mix(with: .white, by: 0.45)).padding(4 * unit)
                }
                .frame(width: 17 * unit, height: 17 * unit)
                .offset(at(side * x, bodyTop + 6))
            }
        case .antennae:
            ForEach([-1.0, 1.0], id: \.self) { side in
                VStack(spacing: 0) {
                    Circle().fill(look.hornColor ?? light)
                        .overlay(Circle().stroke(outline, lineWidth: 1.5 * unit))
                        .frame(width: 11 * unit)
                    Rectangle().fill(dark).frame(width: 3 * unit, height: 16 * unit)
                }
                .rotationEffect(.degrees(side * 20))
                .offset(at(side * (x - 6), bodyTop - 8))
            }
        case .none:
            EmptyView()
        }
    }

    // MARK: - Face

    private var face: some View {
        ZStack {
            HStack(spacing: (look.eyes == 3 ? 2 : 5) * unit) {
                ForEach(0..<look.eyes, id: \.self) { index in
                    VStack(spacing: 2 * unit) {
                        brow(index: index)
                        eye
                    }
                }
            }
            .offset(at(0, eyeY - eyeSize * 0.3))
            mouth.offset(at(0, mouthY))
        }
    }

    private func brow(index: Int) -> some View {
        let side: Double = look.eyes == 1 ? 0 : (index == 0 ? -1 : (index == look.eyes - 1 ? 1 : 0))
        return Arc()
            .stroke(Theme.ink, style: StrokeStyle(lineWidth: 1.8 * unit, lineCap: .round))
            .frame(width: eyeSize * 0.6 * unit, height: 3 * unit)
            .rotationEffect(.degrees(180 + (look.angry ? -side * 18 : side * 6)))
    }

    private var eye: some View {
        ZStack {
            Circle().fill(.white)
            switch mood {
            case .defeated:
                Image(systemName: "xmark")
                    .font(.system(size: eyeSize * 0.5 * unit, weight: .black))
                    .foregroundStyle(Theme.ink)
            case .hit:
                Capsule().fill(Theme.ink).frame(width: eyeSize * 0.6 * unit, height: 3 * unit)
            case .idle, .laugh:
                Circle().fill(Theme.ink)
                    .frame(width: eyeSize * 0.5 * unit)
                    .overlay(alignment: .topLeading) {
                        Circle().fill(.white)
                            .frame(width: eyeSize * 0.17 * unit)
                            .offset(x: eyeSize * 0.07 * unit, y: eyeSize * 0.07 * unit)
                    }
                    .offset(y: mood == .laugh ? -eyeSize * 0.1 * unit : eyeSize * 0.03 * unit)
            }
        }
        .frame(width: eyeSize * unit, height: eyeSize * unit)
        .overlay(Circle().stroke(outline, lineWidth: 1.5 * unit))
    }

    @ViewBuilder
    private var mouth: some View {
        switch mood {
        case .hit, .defeated:
            Ellipse().fill(Theme.ink).frame(width: 10 * unit, height: 12 * unit)
        case .laugh:
            openMouth(width: 32, height: 17)
        case .idle:
            switch look.mouth {
            case .smileFangs:
                Arc()
                    .stroke(Theme.ink, style: StrokeStyle(lineWidth: 2 * unit, lineCap: .round))
                    .frame(width: 26 * unit, height: 7 * unit)
                    .overlay(alignment: .bottom) {
                        HStack(spacing: 10 * unit) { fang; fang }.offset(y: 3 * unit)
                    }
            case .grin:
                openMouth(width: 26, height: 13)
            case .toothy:
                HalfCircle()
                    .fill(Theme.ink)
                    .overlay(alignment: .top) {
                        HStack(spacing: 2 * unit) {
                            ForEach(0..<4, id: \.self) { _ in
                                Rectangle().fill(.white).frame(width: 3.5 * unit, height: 3.5 * unit)
                            }
                        }
                    }
                    .frame(width: 26 * unit, height: 9 * unit)
            case .tiny:
                Arc()
                    .stroke(Theme.ink, style: StrokeStyle(lineWidth: 2 * unit, lineCap: .round))
                    .frame(width: 13 * unit, height: 4 * unit)
            }
        }
    }

    private func openMouth(width: CGFloat, height: CGFloat) -> some View {
        HalfCircle()
            .fill(Color(red: 0.18, green: 0.2, blue: 0.42))
            .overlay(alignment: .bottom) {
                Ellipse().fill(Color(red: 1, green: 0.5, blue: 0.55))
                    .frame(width: width * 0.45 * unit, height: height * 0.4 * unit)
                    .offset(y: -height * 0.12 * unit)
            }
            .overlay(alignment: .top) { HStack(spacing: width * 0.3 * unit) { fang; fang } }
            .clipShape(HalfCircle())
            .frame(width: width * unit, height: height * unit)
    }

    private var fang: some View {
        Triangle().fill(.white).frame(width: 5 * unit, height: 5 * unit).rotationEffect(.degrees(180))
    }

    // MARK: - Signature extras of the original monsters

    @ViewBuilder
    private var front: some View {
        switch monster {
        case .snake:
            Capsule()
                .fill(Theme.bad)
                .frame(width: 5 * unit, height: 14 * unit)
                .offset(at(0, mouthY + 12))
                .opacity(mood == .laugh ? 1 : 0)
        case .traps:
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3 * unit).fill(Theme.ink).frame(width: 26 * unit, height: 20 * unit)
                Capsule().fill(Theme.ink).frame(width: 42 * unit, height: 6 * unit)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.bad).frame(width: 26 * unit, height: 4 * unit).offset(y: -6 * unit)
            }
            .rotationEffect(.degrees(-12))
            .offset(at(8, bodyTop - 8))
        default:
            EmptyView()
        }
    }
}

/// The building blocks of each monster's look.
struct MonsterLook {
    enum Shape { case tall, round, pear }
    enum Ears { case horns, bunny, elf, round, antennae, none }
    enum Mouth { case smileFangs, grin, toothy, tiny }

    var shape: Shape
    var ears: Ears
    var eyes: Int
    var mouth: Mouth
    var furry = false
    var tuft = false
    var angry = false
    var hornColor: Color?

    static func of(_ monster: MonsterID) -> MonsterLook {
        switch monster {
        case .ae: MonsterLook(shape: .round, ears: .none, eyes: 1, mouth: .toothy, furry: true, tuft: true)
        case .noNo: MonsterLook(shape: .tall, ears: .horns, eyes: 2, mouth: .smileFangs, angry: true, hornColor: Theme.ink)
        case .jumper: MonsterLook(shape: .round, ears: .antennae, eyes: 2, mouth: .grin, hornColor: Theme.gold)
        case .snake: MonsterLook(shape: .pear, ears: .elf, eyes: 2, mouth: .smileFangs, tuft: true)
        case .traps: MonsterLook(shape: .round, ears: .round, eyes: 2, mouth: .grin, furry: true)
        case .gotLost: MonsterLook(shape: .tall, ears: .bunny, eyes: 2, mouth: .tiny, tuft: true)
        default: generated(monster)
        }
    }

    /// The Movers monsters mix the same parts in different combinations; their colour is unique.
    private static func generated(_ monster: MonsterID) -> MonsterLook {
        let i = max(0, monster.index - MonsterGroup.core.monsters.count)
        let ears: [Ears] = [.horns, .bunny, .elf, .round, .antennae]
        let mouths: [Mouth] = [.smileFangs, .grin, .toothy, .tiny]
        return MonsterLook(
            shape: [.tall, .round, .pear][i % 3],
            ears: ears[i % ears.count],
            eyes: [2, 2, 3, 2, 1][(i / 2) % 5],
            mouth: mouths[(i + i / 4) % mouths.count],
            furry: i % 2 == 1,
            tuft: i % 3 != 1,
            angry: monster == .bossy,
            hornColor: i % 10 == 5 ? monster.color.mix(with: .white, by: 0.5) : nil
        )
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

/// A curve that dips in the middle: a smile, or a brow when turned upside down.
private struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.maxY * 2))
        }
    }
}

/// A horn curving outwards to the right; mirror it for the left side.
private struct Horn: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                              control: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.2))
            path.addQuadCurve(to: CGPoint(x: rect.maxX * 0.85, y: rect.maxY),
                              control: CGPoint(x: rect.width * 0.6, y: rect.height * 0.45))
            path.closeSubpath()
        }
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))]) {
            ForEach(MonsterID.allCases) { MonsterView(monster: $0, size: 90) }
        }
    }
}
