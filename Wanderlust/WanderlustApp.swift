//
//  WanderlustApp.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 22/02/24.
//

import SwiftUI

@main
struct WanderlustApp: App {
    @State private var hotelViewModel = HotelViewModel()
    @State private var hotelPlayerViewModel = HotelPlayerViewModel()
    @State private var chatViewmodel = ViewModel()
    @State private var player = SpatialPlayerModel()
    
    var body: some Scene {
            
        WindowGroup(id: "ConverseView") {
            ConversationView(hotelViewModel: hotelViewModel)
        }.windowStyle(.plain).defaultSize(width: 0.85, height:0.9, depth: 1, in: .meters)
        WindowGroup(id: "HotelListView") {
            HotelListView(viewModel: hotelViewModel)
                .cornerRadius(16)
        }.windowStyle(.plain)
            .defaultSize(width: 1.45, height: 0.45, depth: 1, in: .meters)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            HotelistImmersiveView(viewModel: hotelViewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        ImmersiveSpace(id: "HotelImmersiveSpace") {
            HotelImmersiveView(viewModel: hotelPlayerViewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        ImmersiveSpace(id: "RoomTour") {
            ImmersiveView(viewModel: hotelViewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        WindowGroup(id: "SpatialVideo") {
            SpatialContentView()
                .environment(player)
        }
    }
}


