//
//  MapView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import SwiftUI
import MapKit

//MapView -> LocationView

//This is the view for that shows the map and allows searches with random query, coordination for location. it can also just ghrab user's current location instead

struct MapView: View {
    @StateObject private var mapSearch = MapSearcher()      //An instance of the observable object that manage search processes
    @EnvironmentObject var locationManager: LocationCacher  //Receive env variable for stored location save, modify &delete
    @State private var queryText = ""                       //Variable to observe textfield for input query
    @State private var queryLat = ""                        //Variable to observe textfield for input latitude
    @State private var queryLon = ""                        //Variable to observe textfield for input longitude
    @State private var locSelect: Bool = false              //A varibale to observe if a location is selected (open info for that loc)
    
    @State private var selectedCat: SearchCategory = .randomQuery   //A variable to observe the current searching option
    @State private var isCurrentLoc: Bool = false           //A varibale to check if the location showed up is the current location
    @State var isAlert: Bool = false                        //A variable to observe if the alert should be shown
    
    var body: some View {
        VStack {
            switch selectedCat {
            case .randomQuery:
                //Input texfield and button for random query (vague search -> return the result that is most relevant)
                HStack {
                    //When search, the result will not be user's current location anymore, show alert if there is no result for the search
                    //Random query search allows users to click enter on keyboard to search or use the search button
                    TextField("Enter location query", text: $queryText, onCommit: {
                        mapSearch.locationSearch(query: queryText)
                        isCurrentLoc = false
                        if mapSearch.locationPin == nil {
                            isAlert = true
                        }
                    })
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    //Search button for query search
                    //Call the corresponding search in MapSearch and dismiss user's keyboard (this is needed as the keyboard will obstruct the tab view)
                    Button(action: {
                        mapSearch.locationSearch(query: queryText)
                        isCurrentLoc = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        //Trigger alert if no result found to notice user
                        if mapSearch.locationPin == nil {
                            isAlert = true
                        }
                    }) {
                        //Label for the button
                        HStack {
                            Text("Search")
                            Image(systemName: "magnifyingglass.circle")
                        }
                        .padding(5)
                    }
                    //Disable the button when the textfield is empty, change color correspondingly to whether the textfiled is empoty or not (gray == empty, blue == have input text)
                    .disabled(queryText.isEmpty)
                    .foregroundStyle(.white)
                    .background(queryText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
            case .coordination:
                //Input textfields and search button coordinate search
                HStack {
                    //2 textfields for latitude and longitude input
                    TextField("Enter latitude", text: $queryLat)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Enter longitude", text: $queryLon)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    //The search button for the coordinate search
                    Button(action: {
                        //Call corresponding search from MapSearch
                        mapSearch.coorSearch(lat: queryLat, lon: queryLon)
                        isCurrentLoc = false
                        //Dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        //Show alert if extreme location coordination is used to search
                        if mapSearch.locationPin == nil || mapSearch.locationPin?.coordinate.latitude ?? 86 >= 85 || mapSearch.locationPin?.coordinate.latitude ?? 86 <= -85 || mapSearch.locationPin?.coordinate.longitude ?? 181 > 180 || mapSearch.locationPin?.coordinate.longitude ?? 181 < -180 {
                            isAlert = true
                        }
                    }) {
                        //Label for the button
                        HStack {
                            Text("Search")
                            Image(systemName: "magnifyingglass.circle")
                        }
                        .padding(5)
                    }
                    //Disable if the coordinate input is not valid, gray button for invalid input, blue for valid input
                    .disabled(!isValidCoor())
                    .foregroundStyle(.white)
                    .background(isValidCoor() ? Color.blue : Color.gray)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
            case .currentLoc:
                // A title showiung that user is using user's current coordination option
                Text("User Current Location")
                    .font(.title)
            }
            
            //The horizonrtal picker to navigate between different search options mentioned above
            SearchPickerView(selectedCat: $selectedCat)
            
            //The map that will show result pin for the search query/coordination/user location that can be tapped on for location's air quality forecast info
            Map(position: $mapSearch.camPos) {
                //Safely unwrap the info of the LocationPin and give it corresponding labels
                if let pin = mapSearch.locationPin {
                    Annotation((isCurrentLoc ? "Current Position" : "Destination"), coordinate:pin.coordinate) {
                        Button(action: {
                            locSelect = true
                        }) {
                            Image(systemName: (isCurrentLoc ? "location.circle.fill" : "mappin.circle.fill"))
                                .font(.title)
                                .foregroundStyle(isCurrentLoc ? .blue : .red)
                        }
                        //Information of location's air quality forecast is shown in a sheet view
                        .sheet(isPresented: $locSelect) {
                            NavigationStack {
                                LocationView(lat: pin.coordinate.latitude, lon: pin.coordinate.longitude, locationTitle: "", id: UUID.sentinel)
                                    .presentationDragIndicator(.visible)
                                    .environmentObject(locationManager)
                            }
                            
                        }
                        
                    }
                }
            }
            //When the map appear, get the user's coordination (This only works if user allows location access)
            .onAppear {
                Task {
                    isCurrentLoc = true
                    mapSearch.getCurrentLocation()
                }
            }
            .mapStyle(.standard)
        }
        //When the view appear, reset the chosen option (random query is initial option), reset textfields
        .onAppear {
            selectedCat = .randomQuery
            queryText = ""
            queryLat = ""
            queryLon = ""
        }
        //When the search option changes, reset textfields, get user coordination if search option is user's location
        .onChange(of: selectedCat) {
            if (selectedCat == .currentLoc) {
                isCurrentLoc = true
                mapSearch.getCurrentLocation()
            }
            queryText = ""
            queryLat = ""
            queryLon = ""
        }
        //The aleart that is triggered when search is not found or search coordination are extreme
        .alert("No result was found, or this is an extreme coordinate search. Please move the map around to find your located pin. If no pin was found, please try another search!", isPresented: $isAlert) {
            Button("Close", role: .cancel) {}
         }
    }
    
    
    
    
    //Extra func to check lat value in the textfields
    func checkLat(lat: String) -> Bool {
        if let latitude = Double(lat) {
            if (latitude > 90 || latitude < -90) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    //Extra func to check lon value in the textfields
    func checkLon(lon: String) -> Bool {
        if let longitude = Double(lon) {
            if (longitude > 180 || longitude < -180) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    //Extra function utilise the 2 above to check if the input coordinate is valid
    func isValidCoor() -> Bool {
        if checkLat(lat: queryLat) && checkLon(lon: queryLon) && !queryLat.isEmpty && !queryLon.isEmpty {
            return true
        } else {
            return false
        }
    }

}



//The enum that responsible for tracking the current search option
enum SearchCategory: String, CaseIterable, Identifiable {
    case randomQuery = "Query"
    case coordination = "Coordinate"
    case currentLoc = "Current Location"
    
    //To conform Identifiable
    var id: String { rawValue }
}



#Preview {
    MapView()
        .environmentObject(LocationCacher())
}

