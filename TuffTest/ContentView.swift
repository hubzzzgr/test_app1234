import SwiftUI
import AVFoundation
import UIKit

@main
struct TuffTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @State private var torch = TorchController()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.10, blue: 0.16), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Button(action: testDevice) {
                Text("test")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 176, height: 64)
                    .background {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Capsule().fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.24), .white.opacity(0.035), .white.opacity(0.10)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            }
                            .overlay {
                                Capsule().strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.68), .white.opacity(0.12), .white.opacity(0.30)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 1
                                )
                            }
                            .shadow(color: .white.opacity(0.10), radius: 18, y: 8)
                    }
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Gently vibrates and briefly flashes the flashlight")
        }
    }

    private func testDevice() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.55)
        torch.flash()
    }
}

@MainActor
final class TorchController: ObservableObject {
    private var device: AVCaptureDevice? {
        AVCaptureDevice.default(for: .video)
    }

    func flash() {
        guard let device, device.hasTorch else { return }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            pulse(device)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                guard allowed else { return }
                Task { @MainActor in
                    guard let device = self?.device, device.hasTorch else { return }
                    self?.pulse(device)
                }
            }
        default:
            break
        }
    }

    private func pulse(_ device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 1.0)
            device.unlockForConfiguration()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { [weak self] in
                guard let self else { return }
                try? device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            }
        } catch {
            if device.isLockedForConfiguration == false {
                try? device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            }
        }
    }
}
