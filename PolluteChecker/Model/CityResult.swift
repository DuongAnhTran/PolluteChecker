//
//  CityResult.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//

import Foundation
import CoreLocation

struct CityResult: Codable, Identifiable {
    var id = UUID()
    let cityName: String
    let country: String
    let lat: Double
    let lon: Double
    
    var cityLabel: String { "\(cityName), \(country)" }
    
}




