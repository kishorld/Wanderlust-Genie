import AVKit
import SwiftUI

struct SpatialPlayerView: View, UIViewControllerRepresentable {

    @Environment(SpatialPlayerModel.self) private var model

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = model.makePlayerViewController()
        controller.allowsPictureInPicturePlayback = true
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        Task { @MainActor in
            controller.contextualActions = []
        }
    }
}
