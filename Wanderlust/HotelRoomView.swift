//
//  HotelRoomView.swift
//  HotelView
//
//  Created by Shamanth R on 26/02/24.
//

import SwiftUI
import RealityKit

struct HotelRoomView: View {

    var viewModel: HotelPlayerViewModel

    @State private var showImmersiveSpace = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            VStack {
                Toggle(isOn: $showImmersiveSpace) {
                    Text(showImmersiveSpace ? "Hide ImmersiveSpace" : "Show ImmersiveSpace")
                }
                .toggleStyle(.button)
                .padding()
            }
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "HotelImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

#Preview {
    HotelRoomView(viewModel: HotelPlayerViewModel())
}
