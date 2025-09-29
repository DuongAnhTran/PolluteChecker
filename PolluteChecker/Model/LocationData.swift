//
//  LocationData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//


import Foundation


// This will be used for saving favourite location
struct LocationData: Codable, Identifiable {
    var id = UUID()
    let locationName: String
    let lan: Double
    let lon: Double
}
