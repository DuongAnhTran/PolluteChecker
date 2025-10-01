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

//An extension for data type UUID (This is used to creat a sentinel value)
///This sentinel value will determine which version of the **LocationView** will be shown. If sentinel value is passed, the app will be showing the search result version (allows adding new location), if a unique UUID is passed, it will display the saved location version (only allow modification)
extension UUID {
    static let sentinel = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}
