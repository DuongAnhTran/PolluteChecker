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
import CoreLocation


class MapSearcher: ObservableObject {
    @Published var camPos: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @Published var isInitial: Bool = true
    @Published var cityList: [CityResult] = []
    @Published var locationPin: LocationPin? = nil

    
    func getCurrentLocation() {
        CLLocationManager().requestWhenInUseAuthorization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let coordinate = CLLocationManager().location?.coordinate {
                self.camPos = .camera(MapCamera(centerCoordinate: coordinate, distance: 1000))
                self.locationPin = LocationPin(coordinate: coordinate)
            } else {
                print("Location not available yet")
            }
        }
    }
    
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
    
    func citySearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let cities = response?.mapItems else { return }
            
            let results = cities.compactMap { city -> CityResult? in
                let coordinate = city.placemark.coordinate
                let name = city.name ?? "Unknown"
                let country = city.placemark.country ?? "Unknown"
                return CityResult(
                    cityName: name,
                    country: country,
                    lat: coordinate.latitude,
                    lon: coordinate.longitude
                )
            }
            
            DispatchQueue.main.async {
                self.cityList = results
            }
        }
    }
    
}

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

