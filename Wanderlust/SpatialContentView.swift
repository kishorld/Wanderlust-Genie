//
//  ContentView.swift
//  HotelRoomVideo
//
//  Created by Shamanth R on 25/02/24.
//

import SwiftUI

struct SpatialContentView: View {

    @Environment(SpatialPlayerModel.self) private var player
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        VStack {
            SpatialPlayerView()
                .onAppear() {
                                    if let videoURL = Bundle.main.url(forResource: "Room1", withExtension: "MOV") {
                                        let video = SpatialVideo(id: 1, url: videoURL, title: "Spatial Vidoe")
                                        player.loadVideo(video)
                                    } else {
                                        print("Video file not found")
                                    }
                                }
            Button("Back") {
                dismissWindow(id: "SpatialVideo")
            }
        }
    }
}

#Preview {
    SpatialContentView()
        .environment(SpatialPlayerModel())
}
