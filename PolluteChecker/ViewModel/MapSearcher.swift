//
//  MapSearcher.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import MapKit

import Combine
import _MapKit_SwiftUI


class MapSearcher: ObservableObject {
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var locationPin: LocationPin? = nil

    func locationSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.location.coordinate else { return }
            DispatchQueue.main.async {
                self.locationPin = LocationPin(coordinate: coordinate)
                let camera = MapCamera(centerCoordinate: coordinate, distance: 1000)
                self.cameraPosition = .camera(camera)
            }
        }
    }
}

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

