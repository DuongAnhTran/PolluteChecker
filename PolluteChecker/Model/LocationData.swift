//
//  LocationData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//


import Foundation

// This will be used for saving favourite location
/**
    Includes:
        - An unique ID for each of the saved location
        - The name of the location (This will be determined by the user before saving)
        - lat: The latitude of the location
        - lon: The longitude of the location
 
    *Note*: The air quality prediction for the location will be different for each and every day -> API call related
 */
struct LocationData: Codable, Identifiable {
    var id = UUID()
    var locationName: String
    let lat: Double
    let lon: Double
}
