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

//This is a class that responsible for peforming searches

class MapSearcher: ObservableObject {
    //Setting the initial cam position to be on Sydney
    @Published var camPos: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    //The intial Locatrion pin is nothing
    @Published var locationPin: LocationPin? = nil

    //A function that get the user's current location
    func getCurrentLocation() {
        //If the user has not chosen their preference on location setting, ask them
        if CLLocationManager().authorizationStatus == .notDetermined {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        //Wait for 2 sec and then perform location fetching
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
        //Translate the query from plain english to search result of location
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        //fetch the result of the location search
        let search = MKLocalSearch(request: request)
        
        //Unwrap the coordinate from the response and set new camera position and create corresponding location pin
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
        //Safely unwrap input coordinate
        guard let lat = Double(lat), let lon = Double(lon) else {
            return
        }
        //Set the location pin
        self.locationPin = LocationPin(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        //If input lat and lon are extreme, zoom out on the map to make it better for user to find the pin
        if lat >= 85 || lon == 180 || lon == -180{
            self.camPos = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                    span: MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
                )
            )
        //If input coordination is normal then give set the camera position
        } else {
            self.camPos = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), distance: 1000))
        }
            
    }
    
}


//A minor struct to hold information for the location pin, each pin has an ID and a coordinate
struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

