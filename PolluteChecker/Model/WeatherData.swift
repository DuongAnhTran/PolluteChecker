//
//  WeatherData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation

// Weather data model to receive air quality data from open-meteo import
/**
    The air quality model will be containing a smaller struct that contains the arrays for each of the
        air quality criteria (the arrays has 24 items for 24h prediction)
*/
struct WeatherData: Codable, Identifiable {
    let hourly: Hourly
    var id = UUID()
    
    struct Hourly: Codable {
        let time: [Date]
        let pm25: [Float]
        let carbonMonoxide: [Float]
        let carbonDioxide: [Float]
        let nitrogenDioxide: [Float]
        let sulphurDioxide: [Float]
        let ozone: [Float]
        let pm10: [Float]
    }
}


extension WeatherData {
    static var empty: WeatherData {
        .init(hourly: .init(time: [], pm25: [], carbonMonoxide: [], carbonDioxide: [], nitrogenDioxide: [], sulphurDioxide: [], ozone: [], pm10: []))
    }
}
