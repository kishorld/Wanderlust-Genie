//
//  ImmersiveView.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 22/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine
import MapKit

struct ImmersiveView: View {
    static var textureRequest: AnyCancellable?
    static var contentEntity = Entity()

    @StateObject var viewModel: HotelViewModel
    @State var shouldShowText = true

    @State var animationEntity: Entity? = nil
    @State var levitateAnimation: AnimationResource? = nil

    // Anchor position for bot
    @State var chatbotEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [1.5,-0.05, -3.0]
        let radians = -120 * Float.pi / 180
        ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
        return headAnchor
    }()
     
    // Plane for map
    @State var planeEntity: Entity = {
        let wallAnchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0.008, 0.008)))
        
        return wallAnchor
    }()

    var body: some View {
        RealityView { content  in
            do
            {
                //
                
                // Add bot to the view
                //                let bot = try await Entity(named: "Chatbot", in: realityKitContentBundle)
                //                chatbotEntity.addChild(bot)
                //                content.add(planeEntity)
                //                content.add(chatbotEntity)
                //                bot.setScale([0.08, 0.08, 0.08], relativeTo: bot)
                //
                //                // chat view on top of the bot
                //                guard let attachmentEntity = attachments.entity(for: "attachment") else { return }
                //                attachmentEntity.position = SIMD3<Float>(0.5, 0.5, 0)
                //                let radians = 120 * Float.pi / 180
                //                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                //                chatbotEntity.addChild(attachmentEntity)
                
                // Add 3d room in immersive view
                if let selectedRoom = viewModel.selectedRoom
                {
                    let room = try await Entity(named: "\(selectedRoom.sceneName)", in: realityKitContentBundle)
                    content.add(room)
                    if selectedRoom.id == 1 {
                        room.setScale([0.01,0.01,0.01], relativeTo: nil)
                    }
                    // Add panaromic lobby view as immersive view
                    room.addChild(ImmersiveView.setUpImmersiveEntity())

                }
                else {
                    // do nothing
                }
                
                //                guard let transform = attachments.entity(for: "mapWindow") else { return }
                //                let flip = 270 * Float.pi / 180
                //                ImmersiveView.rotateEntityAroundXAxis(entity: transform, angle: flip)
                //                planeEntity.addChild(transform)
                
            }
            catch
            {
                print("error in reality view:\(error)")
            }
        }
    }
    
    // Add room
    static func setUpImmersiveEntity() -> Entity {
        let mod = ModelEntity()
        ImmersiveView.textureRequest = TextureResource.loadAsync(named: "park_scene").sink { (error) in
            print(error)
        } receiveValue: { (texture) in
            var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))
            mod.components.set(ModelComponent(
                mesh: .generateSphere(radius: 1E3),
                materials: [material]
            ))
            mod.scale *= .init(x: -1, y: 1, z: 1)
            mod.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
        }
        ImmersiveView.contentEntity.addChild(mod)
        return ImmersiveView.contentEntity
    }
    
    // Show text
    private func showIntro()
    {
        Task
        {
            if !shouldShowText
            {
                withAnimation(.smooth(duration: 0.3)) {
                    shouldShowText.toggle()
                }
            }
        }
    }
    
    // Add panaromic view
    static func loadImageMaterial(imageUrl: String) -> SimpleMaterial {
        do {
            
            let texture = try TextureResource.load(named: imageUrl)
            var material = SimpleMaterial()
            material.baseColor = MaterialColorParameter.texture(texture)
            return material
        } catch {
            fatalError(String(describing: error))
        }
    }
    
    static func rotateEntityAroundYAxis(entity: Entity, angle: Float) {
        // Get the current transform of the entity
        var currentTransform = entity.transform

        // Create a quaternion representing a rotation around the Y-axis
        let rotation = simd_quatf(angle: angle, axis: [0, 1, 0])

        // Combine the rotation with the current transform
        currentTransform.rotation = rotation * currentTransform.rotation

        // Apply the new transform to the entity
        entity.transform = currentTransform
    }
    
    static func rotateEntityAroundXAxis(entity: Entity, angle: Float) {
        // Get the current transform of the entity
        var currentTransform = entity.transform

        // Create a quaternion representing a rotation around the X-axis
        let rotation = simd_quatf(angle: angle, axis: [1, 0, 0])

        // Combine the rotation with the current transform
        currentTransform.rotation = rotation * currentTransform.rotation

        // Apply the new transform to the entity
        entity.transform = currentTransform
    }
}
