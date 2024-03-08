import AVKit
import Combine
import Observation

@Observable class SpatialPlayerModel {

    private(set) var isPlaying = false
    private(set) var isPlaybackComplete = false
    private(set) var currentItem: SpatialVideo? = nil
    private(set) var shouldProposeNextVideo = false
    private var player = AVPlayer()

    private var playerViewController: AVPlayerViewController? = nil
    private var playerViewControllerDelegate: AVPlayerViewControllerDelegate? = nil

    private(set) var shouldAutoPlay = true

    private var coordinator: VideoWatchingCoordinator! = nil

    private var timeObserver: Any? = nil
    private var subscriptions = Set<AnyCancellable>()

    init() {
        coordinator = VideoWatchingCoordinator(playbackCoordinator: player.playbackCoordinator)
        observePlayback()
        Task {
            await configureAudioSession()
            await observeSharedVideo()
        }
    }

    func makePlayerViewController() -> AVPlayerViewController {
        let delegate = PlayerViewControllerDelegate(player: self)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.delegate = delegate
        
        controller.showsPlaybackControls = true

        playerViewController = controller
        playerViewControllerDelegate = delegate

        return controller
    }

    private func observePlayback() {
        guard subscriptions.isEmpty else { return }

        player.publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] status in
                self?.isPlaying = status == .playing
            }
            .store(in: &subscriptions)

        NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPlaybackComplete = true
            }
            .store(in: &subscriptions)

        NotificationCenter.default
            .publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let result = InterruptionResult(notification) else { return }
                if result.type == .ended && result.options == .shouldResume {
                    self?.player.play()
                }
            }.store(in: &subscriptions)

        addTimeObserver()
    }

    private func configureAudioSession() async {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .moviePlayback, options: .duckOthers)
            try session.setActive(true)
        } catch {
            print("Unable to configure audio session: \(error.localizedDescription)")
        }
    }


    private func observeSharedVideo() async {
        let current = currentItem
        await coordinator.$sharedVideo
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .filter { $0 != current }
            .sink { [weak self] video in
                guard let self = self else { return }
                self.loadVideo(video)
            }
            .store(in: &subscriptions)
    }

    func loadVideo(_ video: SpatialVideo, autoplay: Bool = true) {
        currentItem = video
        shouldAutoPlay = autoplay
        isPlaybackComplete = false

        replaceCurrentItem(with: video)

        configureAudioExperience()
    }

    private func replaceCurrentItem(with video: SpatialVideo) {
        let playerItem = AVPlayerItem(url: video.url)
        playerItem.externalMetadata = createMetadataItems(for: video)
        player.replaceCurrentItem(with: playerItem)
        print("🍿 \(video.title) enqueued for playback.")
    }

    func reset() {
        currentItem = nil
        playerViewController = nil
        playerViewControllerDelegate = nil
    }

    private func createMetadataItems(for video: SpatialVideo) -> [AVMetadataItem] {
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: video.title,
        ]
        return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
    }

    private func createMetadataItem(for identifier: AVMetadataIdentifier,
                                    value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

    private func configureAudioExperience() {
        let experience: AVAudioSessionSpatialExperience
        experience = .headTracked(soundStageSize: .small, anchoringStrategy: .front)
        do {
            try AVAudioSession.sharedInstance().setIntendedSpatialExperience(experience)
        } catch {
            print("Unable to set intended spatial experience: \(error.localizedDescription)")
        }
    }

    // MARK: - Transport Control

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func togglePlayback() {
        player.timeControlStatus == .paused ? play() : pause()
    }

    // MARK: - Time Observation

    private func addTimeObserver() {
        removeTimeObserver()
        let timeInterval = CMTime(value: 1, timescale: 1)
        timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { [weak self] time in
            guard let self = self, let duration = self.player.currentItem?.duration else { return }
            let isInProposalRange = time.seconds >= duration.seconds - 10.0
            if self.shouldProposeNextVideo != isInProposalRange {
                self.shouldProposeNextVideo = isInProposalRange
            }
        }
    }

    private func removeTimeObserver() {
        guard let timeObserver = timeObserver else { return }
        player.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }

    final class PlayerViewControllerDelegate: NSObject, AVPlayerViewControllerDelegate {

        let player: SpatialPlayerModel

        init(player: SpatialPlayerModel) {
            self.player = player
        }

        func playerViewController(_ playerViewController: AVPlayerViewController,
                                  willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            Task {
                await self.player.reset()
            }
        }
    }
}

struct InterruptionResult {

    let type: AVAudioSession.InterruptionType
    let options: AVAudioSession.InterruptionOptions

    init?(_ notification: Notification) {
        guard let type = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType,
              let options = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions else {
            return nil
        }
        self.type = type
        self.options = options
    }
}
