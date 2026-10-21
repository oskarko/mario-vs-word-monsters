import AVFoundation
import SwiftUI

/// Apps can't download voices themselves, so when only the basic (compact) English voices are
/// installed — common on a new iPad — this walks the parent through downloading a clear one.
/// It notices the download on its own and closes.
struct VoiceSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(SettingsKey.voiceSetupDismissed) private var dismissedForever = false
    @State private var ready = Speaker.hasClearEnglishVoice

    private let steps = [
        "Abre la app **Ajustes** del iPad o iPhone.",
        "Entra en **Accesibilidad → Contenido leído → Voces**.",
        "Toca **Inglés** y elige **Serena** o **Kate** (Reino Unido).",
        "Descarga la versión **Mejorada** (son unos 100 MB, mejor con wifi).",
        "Vuelve aquí: la app la usará sola.",
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MonsterView(monster: .ae, mood: ready ? .laugh : .idle, size: 110)
                        .frame(maxWidth: .infinity)
                    if ready {
                        Text("¡Voz clara lista!").font(Theme.title(26))
                        Text("Ya está descargada. A partir de ahora las tarjetas en inglés se oirán claras.")
                            .font(Theme.body(17))
                        Button("Probar voz") { Speaker.shared.english("You have got a dog.") }
                            .buttonStyle(ChunkyButtonStyle(color: Theme.good))
                    } else {
                        Text("Descarga una voz inglesa clara").font(Theme.title(26))
                        Text("Este dispositivo solo tiene las voces básicas, que a veces pronuncian mal algunas palabras. La app no puede descargarlas por sí sola, pero tú sí, en un minuto:")
                            .font(Theme.body(17))
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(steps.indices, id: \.self) { index in
                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                    Text("\(index + 1)").font(Theme.title(18)).foregroundStyle(Theme.neutral)
                                    Text((try? AttributedString(markdown: steps[index])) ?? AttributedString(steps[index])).font(Theme.body(17))
                                }
                            }
                        }
                        .cardStyle()
                        HStack(spacing: 18) {
                            Button("Ya la he descargado") { ready = Speaker.hasClearEnglishVoice }
                                .buttonStyle(ChunkyButtonStyle())
                            Button("No volver a mostrar") {
                                dismissedForever = true
                                dismiss()
                            }
                            .font(Theme.body(16))
                        }
                    }
                }
                .foregroundStyle(Theme.ink)
                .padding(24)
                .readableWidth()
            }
            .background(Theme.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(ready ? "Listo" : "Ahora no") { dismiss() }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVSpeechSynthesizer.availableVoicesDidChangeNotification)) { _ in
            ready = Speaker.hasClearEnglishVoice
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            ready = Speaker.hasClearEnglishVoice
        }
    }
}
