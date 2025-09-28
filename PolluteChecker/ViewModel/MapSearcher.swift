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
    @Published var camPos: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    
    @Published var locationPin: LocationPin? = nil

    func locationSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            DispatchQueue.main.async {
                self.locationPin = LocationPin(coordinate: coordinate)
                self.camPos = .camera(MapCamera(centerCoordinate: coordinate, distance: 1000))
            }
        }
    }
}

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

