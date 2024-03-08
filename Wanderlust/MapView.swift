//
//  MapView.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 26/02/24.
//

import SwiftUI
import MapKit
import CoreLocation
import RealityKit

struct LocationObj: Identifiable, Equatable {
    var id: Int
    var name: String
    let coordinate: CLLocationCoordinate2D
    let panoID: String

    static let example = LocationObj(id: 1, name: "Buckingham Palace", coordinate: .groosevelt, panoID: "")


    static func ==(lhs: LocationObj, rhs: LocationObj) -> Bool {
        lhs.id == rhs.id
    }
}

struct MapRealityView: View {
    @StateObject var hotelViewModel: HotelViewModel

    // Plane for map
    @State var planeEntity: Entity = {
        let wallAnchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0.008, 0.008)))
        
        return wallAnchor
    }()

    var body: some View {
        RealityView { content, attachments in
            do
            {
                guard let transform = attachments.entity(for: "mapWindow") else { return }
                //                let flip = 270 * Float.pi / 180
                //                ImmersiveView.rotateEntityAroundXAxis(entity: transform, angle: flip)
                planeEntity.addChild(transform)
                content.add(planeEntity)
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

struct MapView: View {
    @StateObject var hotelViewModel: HotelViewModel

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @State private var showImmersiveSpace = false

    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: .groosevelt,span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    @State private var selectedTag: Int?
    @State private var selectedLocation: LocationObj?
    @State private var locations = [LocationObj(id: 1, name: "The Peninsula  New York", coordinate: .penensulaNewYork, panoID:  "SIJGWvltPjixy4IzjC0FUA"),
                                    LocationObj(id: 2, name: "Conrad New York Downtown", coordinate: .conardNewYork, panoID: "S6xu9oHEBBAkFTUWTqjNiA"),
                                    LocationObj(id: 3, name: "The Marmara Park Avenue", coordinate: .marmara, panoID: "88m3GIv1SqJw2ZijJcYm9Q"),
                                    LocationObj(id: 4, name: "Gansevoort Meatpacking", coordinate: .groosevelt, panoID: "clMbijYx6gcAAAQfCNrp5A") ]
    var body: some View {
        NavigationStack {
            
            VStack {
                Map(selection: $selectedTag)
                {
                    ForEach(locations) { location in
                        Annotation("", coordinate: location.coordinate) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.teal)
                                Button(location.name) {
                                    selectedTag = location.id
                                }.padding(5)
                            }
                        }
                    }
                    
                }.onChange(of: selectedTag) {
                    let selectedPlace = locations.first { obj in
                        obj.id == selectedTag
                    }
                    if let place = selectedPlace
                    {
                        selectedLocation = place
                        hotelViewModel.selectedPlaceInfo = PlaceInfo(name: place.name, locationCoordinate: place.coordinate , panoId: place.panoID)
                    }
                    
                }
                Spacer()
            }.padding(10)
                .glassBackgroundEffect()
        }.navigationDestination(item: $selectedTag) { room in
            HotelListView(viewModel: hotelViewModel)
        }
    }
}

extension CLLocationCoordinate2D {
    static let penensulaNewYork = CLLocationCoordinate2D(latitude: 40.7616637, longitude: -73.9753426)
    static let conardNewYork = CLLocationCoordinate2D(latitude: 40.7150886, longitude: -74.0159836)
    static let marmara = CLLocationCoordinate2D(latitude: 40.7454602, longitude: -73.9814185)
    static let groosevelt = CLLocationCoordinate2D(latitude: 40.7398422, longitude: -74.0082891)
}
