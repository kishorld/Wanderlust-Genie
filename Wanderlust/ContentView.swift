//
//  ContentView.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 22/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var chatViewModel = ViewModel()

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("Welcome to Wanderlust")
                .font(.extraLargeTitle2)
            
        })
        .padding(50)
        .glassBackgroundEffect()
        .onAppear(perform: {
            Task {
               await openImmersiveSpace(id: "Chatbot")
            }
        })
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
