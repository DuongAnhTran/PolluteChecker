//
//  LocationView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 27/9/2025.
//

import Foundation
import SwiftUI
import Charts

struct LocationView: View {
    @StateObject var fetcher = APIFetcher()
    @StateObject var manager = LocationManager()
    @State var lat: Double
    @State var lon: Double
    @State var dateArray: [Date] = []
    @State var pm25Array: [Float] = []
    @State var carbonMArray: [Float] = []
    @State var carbonDArray: [Float] = []
    @State var nitroArray: [Float] = []
    @State var sulphurArray: [Float] = []
    @State var ozoneArray: [Float] = []
    @State var pm10Array: [Float] = []

    @State var addLoc: Bool = false
    @State var locName: String = ""
    
    var body: some View {
        
        ScrollView{
            VStack {
                Text("Prediction data for \(dateFormat(Date()))")
                Text("latitude: \(lat)")
                Text("longitude: \(lon)")
            }
            .padding()
            
            //Data part for PM 2.5
            DatafieldView(valueArray: $pm25Array, dateArray: $dateArray, dataTitle: "PM 2.5", graphTitle: "PM 2.5 over time", label: "PM 2.5 (µg/m³)", color: Color.blue)
            
            //Data part for carbon monoxide (CO)
            DatafieldView(valueArray: $carbonMArray, dateArray: $dateArray, dataTitle: "CO", graphTitle: "CO over time", label: "CO (ppm)", color: Color.red)
            
            //Data part for carbon dioxide (CO₂)
            DatafieldView(valueArray: $carbonDArray, dateArray: $dateArray, dataTitle: "CO₂", graphTitle: "CO₂ over time", label: "CO₂ (ppm)", color: Color.green)
            
            //Data part for nitrogen dioxide (NO₂)
            DatafieldView(valueArray: $nitroArray, dateArray: $dateArray, dataTitle: "NO₂", graphTitle: "NO₂ over time", label: "NO₂ (pphm)", color: Color.purple)
            
            //Data part for sulphur dioxide (SO₂)
            DatafieldView(valueArray: $sulphurArray, dateArray: $dateArray, dataTitle: "SO₂", graphTitle: "SO₂ over time", label: "SO₂ (pphm)", color: Color.pink)
            
            //Data part for ozone (O₃)
            DatafieldView(valueArray: $ozoneArray, dateArray: $dateArray, dataTitle: "O₃", graphTitle: "O₃ over time", label: "O₃ (pphm)", color: Color.orange)
            
            //Data part for PM 10
            DatafieldView(valueArray: $pm10Array, dateArray: $dateArray, dataTitle: "PM 10", graphTitle: "PM 10 over time", label: "PM 10 (µg/m³)", color: Color.brown)
            
        }
        .onAppear {
            Task {
                await fetcher.fetchAirQuality(latitude: lat, longitude: lon)
                dateArray = fetcher.weatherData.hourly.time
                pm25Array = fetcher.weatherData.hourly.pm25
                carbonMArray = fetcher.weatherData.hourly.carbonMonoxide
                carbonDArray = fetcher.weatherData.hourly.carbonDioxide
                nitroArray = fetcher.weatherData.hourly.nitrogenDioxide
                sulphurArray = fetcher.weatherData.hourly.sulphurDioxide
                ozoneArray = fetcher.weatherData.hourly.ozone
                pm10Array = fetcher.weatherData.hourly.pm10
            }
        }
        .navigationTitle("Place info")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // The plus button on the top right to add location
                Button(action: {
                    addLoc = true
                }) {
                    Image(systemName: "plus")
                }
                .alert("Please provide a name for this location", isPresented: $addLoc) {
                    TextField("Please enter a name for this location", text: $locName)
                    Button("Add") {
                        manager.addLocation(location: LocationData(locationName: locName, lan: lat, lon: lon))
                        locName = ""
                        addLoc = false
                    }
                    .disabled(locName.isEmpty)
                    
                    Button("Cancel", role: .cancel) {
                        locName = ""
                        addLoc = false
                    }
                    
                }
            }
                
        }
    }
    
    
    
    
    
    func dateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        return formatter.string(from: date)
    }
}


#Preview {
    LocationView(fetcher: APIFetcher(), lat: -33.8688, lon: 151.2093)
}
