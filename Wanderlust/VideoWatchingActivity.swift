import Foundation
import GroupActivities
import CoreTransferable

struct VideoWatchingActivity: GroupActivity, Transferable {

    let video: SpatialVideo

    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.type = .watchTogether
        metadata.title = video.title
        metadata.supportsContinuationOnTV = true
        return metadata
    }
}
