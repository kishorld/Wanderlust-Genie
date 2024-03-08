//
//  HotelImmersiveView.swift
//  HotelView
//
//  Created by Shamanth R on 26/02/24.
//
import SwiftUI
import RealityKit

struct HotelImmersiveView: View {

    var viewModel: HotelPlayerViewModel

    var body: some View {
        RealityView { content in
            content.add(viewModel.setupContentEntity())
        }
        .onAppear() {
            viewModel.play()
        }
        .onDisappear() {
            viewModel.pause()
        }
    }
}

#Preview {
    HotelImmersiveView(viewModel: HotelPlayerViewModel())
        .previewLayout(.sizeThatFits)
}
