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
    //Declare a initial. WeatherData object for the class
    @Published var weatherData: WeatherData = .empty
    
    //Fetching air quality from the flatbuffer of open-meteo through given latitude and longitude
    func fetchAirQuality(latitude: Double, longitude: Double) async {
        //URL for Open-Meteo API Flatbuffer format, will return nothing if there is no data
        guard let url = URL(string: "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&hourly=pm2_5,carbon_monoxide,carbon_dioxide,nitrogen_dioxide,sulphur_dioxide,ozone,pm10&timezone=auto&forecast_days=1&format=flatbuffers") else { return }
        
        //Check if it is possible to fetch information from flatbuffer, if not try json fetch instead
        if let responses = try? await WeatherApiResponse.fetch(url: url), let response = responses.first, let hourly = response.hourly {
            //This is for the UTC offset - which is determined automatically by the API as timezone is auto
            let offset = response.utcOffsetSeconds
            
            //Assigning the published variable with the found data from the API
            //The API will be returning data in a list of array, each position is corresponding to each of the fetched data
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
        } else {
            //This is in case the flatbuffer did not work properly (low chance this will be called - 2nd option)
            guard let jsonURL = URL(string: "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&hourly=pm2_5,carbon_monoxide,carbon_dioxide,nitrogen_dioxide,sulphur_dioxide,ozone,pm10&timezone=auto&forecast_days=1&format=json") else { return }

            //Do-catch to avoid unexpected error
            do {
                //Grab data from the declared json url and decode json
                let (data, _) = try await URLSession.shared.data(from: jsonURL)
                let decoded = try JSONDecoder().decode(WeatherData.self, from: data)
                
                //Assigning the published variable with the found data from the API
                //The API will be returning data in a list of array, each position is corresponding to each of the fetched data
                weatherData = WeatherData(
                    hourly: .init(
                        time: decoded.hourly.time,
                        pm25: decoded.hourly.pm25,
                        carbonMonoxide: decoded.hourly.carbonMonoxide,
                        carbonDioxide: decoded.hourly.carbonDioxide,
                        nitrogenDioxide: decoded.hourly.nitrogenDioxide,
                        sulphurDioxide: decoded.hourly.sulphurDioxide,
                        ozone: decoded.hourly.ozone,
                        pm10: decoded.hourly.pm10
                    )
                )
            } catch {
                print("JSON fallback failed: \(error)")
            }
        }
        
        
    }
}

