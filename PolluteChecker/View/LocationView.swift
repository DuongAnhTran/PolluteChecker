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
    @EnvironmentObject var manager: LocationCacher
    @State var lat: Double
    @State var lon: Double
    
    
    //Variable to dismiss the sheet
    @Environment(\.dismiss) var dismiss
    
    //Arrays to hold fetched data
    @State var dateArray: [Date] = []
    @State var pm25Array: [Float] = []
    @State var carbonMArray: [Float] = []
    @State var carbonDArray: [Float] = []
    @State var nitroArray: [Float] = []
    @State var sulphurArray: [Float] = []
    @State var ozoneArray: [Float] = []
    @State var pm10Array: [Float] = []
    @State var locationTitle: String
    @State var isLoading: Bool = false
    
    @State var id: UUID
    @State var isModifying: Bool = false
    @State var newLocName: String = ""

    @State var addLoc: Bool = false
    @State var locName: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    Text("Prediction data for \(dateFormat(Date()))")
                    Text("latitude: \(lat)")
                    Text("longitude: \(lon)")
                }
                .padding()
                
                //Data part for PM 2.5
                DatafieldView(valueArray: $pm25Array, dateArray: $dateArray, dataTitle: "PM 2.5", graphTitle: "PM 2.5 over time", label: "(µg/m³)", color: Color.blue, isLoading: $isLoading)
                
                //Data part for carbon monoxide (CO)
                DatafieldView(valueArray: $carbonMArray, dateArray: $dateArray, dataTitle: "Carbon Monoxide (CO)", graphTitle: "CO over time", label: "(µg/m³)", color: Color.red, isLoading: $isLoading)
                
                //Data part for carbon dioxide (CO₂)
                DatafieldView(valueArray: $carbonDArray, dateArray: $dateArray, dataTitle: "Carbon Dioxide (CO₂)", graphTitle: "CO₂ over time", label: "(ppm)", color: Color.green, isLoading: $isLoading)
                
                //Data part for nitrogen dioxide (NO₂)
                DatafieldView(valueArray: $nitroArray, dateArray: $dateArray, dataTitle: "Nitrogen Dioxide (NO₂)", graphTitle: "NO₂ over time", label: "(µg/m³)", color: Color.purple, isLoading: $isLoading)
                
                //Data part for sulphur dioxide (SO₂)
                DatafieldView(valueArray: $sulphurArray, dateArray: $dateArray, dataTitle: "Sulphur Dioxide (SO₂)", graphTitle: "SO₂ over time", label: "(µg/m³)", color: Color.pink, isLoading: $isLoading)
                
                //Data part for ozone (O₃)
                DatafieldView(valueArray: $ozoneArray, dateArray: $dateArray, dataTitle: "Ozone (O₃)", graphTitle: "O₃ over time", label: "(µg/m³)", color: Color.orange, isLoading: $isLoading)
                
                //Data part for PM 10
                DatafieldView(valueArray: $pm10Array, dateArray: $dateArray, dataTitle: "PM 10", graphTitle: "PM 10 over time", label: "(µg/m³)", color: Color.brown, isLoading: $isLoading)
                
                
                Button(action: {
                    
                }) {
                    NavigationLink {
                        DataExplainView()
                    } label: {
                        Text("Data Explanation")
                    }
                }
                
            }
            .onAppear {
                Task {
                    isLoading = true
                    manager.loadLocation()
                    await fetcher.fetchAirQuality(latitude: lat, longitude: lon)
                    dateArray = fetcher.weatherData.hourly.time
                    pm25Array = fetcher.weatherData.hourly.pm25
                    carbonMArray = fetcher.weatherData.hourly.carbonMonoxide
                    carbonDArray = fetcher.weatherData.hourly.carbonDioxide
                    nitroArray = fetcher.weatherData.hourly.nitrogenDioxide
                    sulphurArray = fetcher.weatherData.hourly.sulphurDioxide
                    ozoneArray = fetcher.weatherData.hourly.ozone
                    pm10Array = fetcher.weatherData.hourly.pm10
                    isLoading = false
                }
            }
            .navigationTitle("\(locationTitle == "" ? "Place Info" : locationTitle)")
            .toolbar {
                if locationTitle == "" || id == UUID.sentinel {
                    ToolbarItem(placement: .topBarTrailing) {
                        // The plus button on the top right to add location
                        Button(action: {
                            addLoc = true
                            if manager.isPlaceExist(lat: lat, lon: lon) {
                                manager.storeExistingName(lat: lat, lon: lon)
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                        .alert(Text((manager.isPlaceExist(lat: lat, lon: lon) ? "This location already exists. Please check the following location name in your saved locations: \(manager.existingName)" : "Please provide a name for this location")), isPresented: $addLoc) {
                            if (!manager.isPlaceExist(lat: lat, lon: lon)) {
                                TextField("Please enter a name for this location", text: $locName)
                                Button("Add") {
                                    manager.addLocation(location: LocationData(locationName: locName, lat: lat, lon: lon))
                                    locName = ""
                                    addLoc = false
                                    dismiss()
                                }
                                .disabled(locName.isEmpty || manager.checkNameExist(name: locName))
                                
                                Button("Cancel", role: .cancel) {
                                    locName = ""
                                    addLoc = false
                                }
                            } else {
                                Button ("Close", role: .cancel) {
                                    addLoc = false
                                    locName = ""
                                }
                            }
                        }
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isModifying = true
                        }) {
                            Image(systemName: "pencil.line")
                        }
                        .alert("Editing Location Name", isPresented: $isModifying) {
                            TextField("Enter new name", text: $newLocName)
                            
                            Button("Save") {
                                manager.modifyLocation(id: id, newName: newLocName)
                                isModifying = false
                                locationTitle = newLocName
                                newLocName = ""
                            }
                            .disabled(newLocName.isEmpty || manager.checkNameExist(name: newLocName))
                            
                            Button("Cancel", role: .cancel) {
                                locationTitle = newLocName
                                newLocName = ""
                                isModifying = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func dateFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}


//Do not do modify here cuz it will break
#Preview {
    LocationView(fetcher: APIFetcher(), lat: -33.8688, lon: 151.2093, locationTitle: "Sydney", id: UUID.sentinel)
            .environmentObject(LocationCacher())
}
