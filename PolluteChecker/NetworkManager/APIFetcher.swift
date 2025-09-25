//
//  APIFetcher.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import OpenMeteoSdk
internal import Combine

class APIFetcher: ObservableObject {
    @Published var weatherData: WeatherData = .empty
    
    
    func fetchAirQuality(latitude: Double, longitude: Double) async -> WeatherData{
        guard let url = URL(string: "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&hourly=carbon_monoxide,carbon_dioxide,nitrogen_dioxide,sulphur_dioxide,ozone,dust&forecast_days=1&format=flatbuffers") else { return .empty }
        
        let responses = try? await WeatherApiResponse.fetch(url: url)
        
        guard let response = responses?.first else { return .empty }
        
        guard let hourly = response.hourly else { return .empty }
        
        let offset = response.utcOffsetSeconds
        
        return WeatherData(
            hourly: .init(
                time: hourly.getDateTime(offset: offset),
                carbonMonoxide: hourly.variables(at: 0)?.values ?? [],
                carbonDioxide: hourly.variables(at: 1)?.values ?? [],
                nitrogenDioxide: hourly.variables(at: 2)?.values ?? [],
                sulphurDioxide: hourly.variables(at: 3)?.values ?? [],
                ozone: hourly.variables(at: 4)?.values ?? [],
                dust: hourly.variables(at: 5)?.values ?? []
            )
        )
        
        
    }
}

