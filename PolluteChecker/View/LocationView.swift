//
//  LocationView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 27/9/2025.
//

import Foundation
import SwiftUI
import Charts

///LocationView -> DatafieldView -> GraphView
///LocationView -> DataExplainView

///This view is used to show the information on the air quality forecast for the chosen location
struct LocationView: View {
    //An instance of the class to fetch info from the API and the environment varibale that is used in the app
    @StateObject var fetcher = APIFetcher()
    @EnvironmentObject var manager: LocationCacher
    
    //Variable for latitude and longitude that is received from the view before (MapView/SavedLocation)
    @State var lat: Double
    @State var lon: Double
    
    
    //Variable to dismiss the sheet
    @Environment(\.dismiss) var dismiss
    
    //Arrays to hold fetched data for each of the air quality element
    @State var dateArray: [Date] = []
    @State var pm25Array: [Float] = []
    @State var carbonMArray: [Float] = []
    @State var carbonDArray: [Float] = []
    @State var nitroArray: [Float] = []
    @State var sulphurArray: [Float] = []
    @State var ozoneArray: [Float] = []
    @State var pm10Array: [Float] = []
    
    
    @State var locationTitle: String           //Title for the view
    @State var isLoading: Bool = false         //Boolean to check if the view is still rendering the data (used for the GraphView)
    @State var id: UUID                        //Location ID (each pair of lat and lon has an ID if already saved - LocationData)
    @State var isModifying: Bool = false       //Check if the location data is being modified (name of saved location)
    @State var newLocName: String = ""         //String to observe the new name given to the location (only if location is saved)

    @State var addLoc: Bool = false            //Check if the location is being added into the local data
    @State var locName: String = ""            //String to observe input location name (when the location is saved for the 1st time)
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                //Information on the current date of forecast + coordination
                VStack {
                    Text("Prediction data for **\(dateFormat(Date()))**")
                    Text("**latitude**: \(lat)")
                    Text("**longitude**: \(lon)")
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
                
                
                //A button to go to the app info and extra explanation on the circle indicating the safetiness of the values
                Button(action: {
                    //Do nothing
                }) {
                    NavigationLink {
                        DataExplainView()
                    } label: {
                        Text("Data Explanation")
                    }
                }
                .padding(.bottom)
            }
            //When the view appear, perform API fetching and populate the created arrays with values
            .onAppear {
                Task {
                    isLoading = true
                    //Load the environment varible's member (locationList) with saved locations - make sure access to the most updated version of the cached data
                    manager.loadLocation()
                    
                    //Fetch data from API and populated created arrays
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
            ///Title of the view. If the previous view gives empty string -> show "Place Info" (if previous view is **MapView**)
            ///Else show the saved location name (this is if the **LocationView** is triggered from **savedLocation**)
            .navigationTitle("\(locationTitle == "" ? "Place Info" : locationTitle)")
            .toolbar {
                if locationTitle == "" || id == UUID.sentinel {
                    
                    ///If the previous view is **MapView** (sentinel/initial values are passed to this view if MapView is previous)
                    ToolbarItem(placement: .topBarTrailing) {
                        // The add button, check if the location with the same coordination already exist before adding
                        Button(action: {
                            addLoc = true
                            if manager.isPlaceExist(lat: lat, lon: lon) {
                                //get the name saved in location, show it later to make it easier for user to find in their saved data
                                manager.storeExistingName(lat: lat, lon: lon)
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                        //Trigger alert when the add button is pressed (have different msg for each situation)
                        .alert(Text((manager.isPlaceExist(lat: lat, lon: lon) ? "This location already exists. Please check the following location name in your saved locations: \(manager.existingName)" : "Please provide a name for this location")), isPresented: $addLoc) {
                            ///Sit 1: place haven't saved before:
                            if (!manager.isPlaceExist(lat: lat, lon: lon)) {
                                TextField("Please enter a name for this location", text: $locName)
                                Button("Add") {
                                    manager.addLocation(location: LocationData(locationName: locName, lat: lat, lon: lon))
                                    locName = ""
                                    addLoc = false
                                    dismiss()
                                }
                                //Do not allow add if using names existed in saved locations, or if textfield empty
                                .disabled(locName.isEmpty || manager.checkNameExist(name: locName))
                                
                                Button("Cancel", role: .cancel) {
                                    locName = ""
                                    addLoc = false
                                }
                            
                            ///Sit 2: The location already saved in the saved location:
                            } else {
                                Button ("Close", role: .cancel) {
                                    addLoc = false
                                    locName = ""
                                }
                            }
                        }
                    }
                } else {
                    
                    ///If the previous view is **savedLocation** (id and location title will be available as it is saved)
                    ToolbarItem(placement: .topBarTrailing) {
                        //Modify button
                        Button(action: {
                            isModifying = true
                        }) {
                            Image(systemName: "pencil.line")
                        }
                        //Trigger alert when choose to modify
                        .alert("Editing Location Name", isPresented: $isModifying) {
                            TextField("Enter new name", text: $newLocName)
                            
                            Button("Save") {
                                manager.modifyLocation(id: id, newName: newLocName)
                                isModifying = false
                                locationTitle = newLocName
                                newLocName = ""
                            }
                            //Does not allow duplicate names in saved locations
                            .disabled(newLocName.isEmpty || manager.checkNameExist(name: newLocName))
                            
                            Button("Cancel", role: .cancel) {
                                newLocName = ""
                                isModifying = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //Extra function to provide dd/MM/yyyy format for dates
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
