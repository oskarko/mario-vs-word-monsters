// Renders the app icon from MonsterView on macOS. Run Scripts/make-icon.sh.
import AppKit
import SwiftUI

enum Haptics { static func tap() {} }

struct IconView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1.0, green: 0.85, blue: 0.35), Color(red: 1.0, green: 0.55, blue: 0.25)],
                           startPoint: .top, endPoint: .bottom)
            Circle().fill(.white.opacity(0.3)).frame(width: 860).offset(y: 10)
            MonsterView(monster: .ae, mood: .laugh, size: 840).offset(y: 30)
        }
        .frame(width: 1024, height: 1024)
    }
}

@MainActor
func render() {
    let renderer = ImageRenderer(content: IconView())
    renderer.scale = 1
    guard let image = renderer.cgImage else { fatalError("render failed") }
    let rep = NSBitmapImageRep(cgImage: image)
    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
}

MainActor.assumeIsolated { render() }
