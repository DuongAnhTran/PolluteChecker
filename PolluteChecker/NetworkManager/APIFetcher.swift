//
//  APIFetcher.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import OpenMeteoSdk
import Combine

// Fetching air quality from open-meteo

class APIFetcher: ObservableObject {
    @Published var weatherData: WeatherData = .empty
    
    
    func fetchAirQuality(latitude: Double, longitude: Double) async {
        guard let url = URL(string: "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&hourly=pm2_5,carbon_monoxide,carbon_dioxide,nitrogen_dioxide,sulphur_dioxide,ozone,pm10&timezone=auto&forecast_days=1&format=flatbuffers") else { return }
        
        let responses = try? await WeatherApiResponse.fetch(url: url)
        
        guard let response = responses?.first else { return }
        
        guard let hourly = response.hourly else { return }
        
        let offset = response.utcOffsetSeconds
        
        weatherData = WeatherData(
            hourly: .init(
                time: hourly.getDateTime(offset: offset),
                pm25: hourly.variables(at: 0)?.values ?? [],
                carbonMonoxide: hourly.variables(at: 1)?.values ?? [],
                carbonDioxide: hourly.variables(at: 2)?.values ?? [],
                nitrogenDioxide: hourly.variables(at: 3)?.values ?? [],
                sulphurDioxide: hourly.variables(at: 4)?.values ?? [],
                ozone: hourly.variables(at: 5)?.values ?? [],
                pm10: hourly.variables(at: 6)?.values ?? []
            )
        )
        
        
    }
}

