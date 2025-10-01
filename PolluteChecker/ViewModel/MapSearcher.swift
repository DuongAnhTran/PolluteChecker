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
    @Published var locationPin: LocationPin? = nil

    
    func getCurrentLocation() {
        if CLLocationManager().authorizationStatus == .notDetermined {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let coordinate = CLLocationManager().location?.coordinate {
                self.camPos = .camera(MapCamera(centerCoordinate: coordinate, distance: 1000))
                self.locationPin = LocationPin(coordinate: coordinate)
            } else {
                print("Location not available yet")
            }
        }
    }
    
    
    //Search using random query, might need specific prompt and information to find exact thing (will return the most relevant result)
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
    
    
    
    //Search function when using lat and lon
    func coorSearch(lat: String, lon: String) {
        guard let lat = Double(lat), let lon = Double(lon) else {
            return
        }
        self.locationPin = LocationPin(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        if lat >= 85 || lon == 180 || lon == -180{
            self.camPos = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                    span: MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
                )
            )
        } else {
            self.camPos = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), distance: 1000))
        }
            
    }
    
}

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

