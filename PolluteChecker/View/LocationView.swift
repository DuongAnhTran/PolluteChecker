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
    @State var yArray: [Float] = []
    @State var addLoc: Bool = false
    @State var locName: String = ""
    
    var body: some View {
        ScrollView{
            Text("Place information:")
                .font(.title)
                .padding()
            
            Text("latitude: \(lat)")
            Text("longitude: \(lon)")
            
            
            GraphView(label: "Dust (µg/m³)", dateArray: dateArray, valueArray: yArray)
            
            // The plus button on the top right to add song
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
            }
        }
        .onAppear {
            Task {
                await fetcher.fetchAirQuality(latitude: lat, longitude: lon)
                dateArray = fetcher.weatherData.hourly.time
                yArray = fetcher.weatherData.hourly.dust
            }
        }
    }
}


#Preview {
    LocationView(fetcher: APIFetcher(), lat: -33.8688, lon: 151.2093)
}
