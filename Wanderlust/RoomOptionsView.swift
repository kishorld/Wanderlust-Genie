//
//  RoomOptionsView.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 03/03/24.
//

import SwiftUI

struct RoomOptionsView: View {
    
    @StateObject var viewModel: HotelViewModel

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(viewModel.rooms) { room in
                VStack {
                    Button(room.title) {
                        Task {
                            viewModel.selectedRoom = room
                            await dismissImmersiveSpace()
                            await openImmersiveSpace(id: "RoomTour")
                        }
                    }
                }
            }        }
        .padding(.bottom, 8)
        .padding(.horizontal, 8)
    }
}

struct Room: Identifiable {
    var id: Int
    var title: String
    var sceneName: String
}


