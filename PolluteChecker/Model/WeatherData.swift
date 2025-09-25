//
//  WeatherData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation


// Weather data model to receive air quality data from open-meteo import
struct WeatherData: Codable, Identifiable {
    let hourly: Hourly
    var id = UUID()
    
    struct Hourly: Codable {
        let time: [Date]
        let carbonMonoxide: [Float]
        let carbonDioxide: [Float]
        let nitrogenDioxide: [Float]
        let sulphurDioxide: [Float]
        let ozone: [Float]
        let dust: [Float]
    }
}


extension WeatherData {
    static var empty: WeatherData {
        .init(hourly: .init(time: [], carbonMonoxide: [], carbonDioxide: [], nitrogenDioxide: [], sulphurDioxide: [], ozone: [], dust: []))
    }
}
