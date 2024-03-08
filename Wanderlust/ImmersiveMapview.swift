//
//  ImmersiveMapview.swift
//  Wanderlust
//
//  Created by Kishor L D on 01/03/24.
//

import SwiftUI
import SwiftUI
import RealityKit
import RealityKitContent
import Combine
import MapKit

struct ImmersiveMapview: View {

    @State var planeEntity: Entity = {
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: SIMD2<Float>(0.008, 0.008)))
        
        return wallAnchor
    }()

    var body: some View {
        
        
        Button("Hi there nbdjbj"){
            
        }
        RealityView { content, attachments in
            do
            {
                guard let transform = attachments.entity(for: "mapWindow") else { return }
                let flip = 270 * Float.pi / 180
//                MapView.rotateEntityAroundYAxis(entity: transform, angle: flip)
                planeEntity.addChild(transform)

            }
            catch
            {
                print("error in reality view:\(error)")
            }
        } update: { _, _ in
        } attachments: {
            
            Attachment(id: "mapWindow") {
                MapView(hotelViewModel: HotelViewModel())
            }
        }
    }
}

#Preview {
    ImmersiveMapview()
        .previewLayout(.sizeThatFits)
}
