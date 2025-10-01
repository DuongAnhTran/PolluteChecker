//
//  MapView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import SwiftUI
import MapKit

//initial map and pin for the

struct MapView: View {
    @StateObject private var mapSearch = MapSearcher()
    @EnvironmentObject var locationManager: LocationCacher
    @State private var queryText = ""
    @State private var queryLat = ""
    @State private var queryLon = ""
    @State private var queryCity = ""
    @State private var locSelect: Bool = false
    @State private var selectedCat: SearchCategory = .randomQuery
    @State private var isCurrentLoc: Bool = false
    @State var isAlert: Bool = false
    
    var body: some View {
        VStack {
            switch selectedCat {
                //View for random query (vague search/address search)
            case .randomQuery:
                HStack {
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
                    
                    
                    Button(action: {
                        mapSearch.locationSearch(query: queryText)
                        isCurrentLoc = false
                        if mapSearch.locationPin == nil {
                            isAlert = true
                        }
                    }) {
                        HStack {
                            Text("Search")
                            Image(systemName: "magnifyingglass.circle")
                        }
                        .padding(5)
                    }
                    .disabled(queryText.isEmpty)
                    .foregroundStyle(.white)
                    .background(queryText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
            case .coordination:
                //View for coordinate search
                HStack {
                    TextField("Enter latitude", text: $queryLat)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Enter longitude", text: $queryLon)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        mapSearch.coorSearch(lat: queryLat, lon: queryLon)
                        isCurrentLoc = false
                        if mapSearch.locationPin == nil || mapSearch.locationPin?.coordinate.latitude ?? 86 >= 85 || mapSearch.locationPin?.coordinate.latitude ?? 86 <= -85 || mapSearch.locationPin?.coordinate.longitude ?? 181 >= 180 || mapSearch.locationPin?.coordinate.longitude ?? 181 <= -180 {
                            isAlert = true
                        }
                    }) {
                        HStack {
                            Text("Search")
                            Image(systemName: "magnifyingglass.circle")
                        }
                        .padding(5)
                    }
                    .disabled(!isValidCoor())
                    .foregroundStyle(.white)
                    .background(isValidCoor() ? Color.blue : Color.gray)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                
            case .currentLoc:
                // View for user loc
                Text("User Current Location")
                    .font(.title)
                
            }
            
            SearchPickerView(selectedCat: $selectedCat)
            
            Map(position: $mapSearch.camPos) {
                if let pin = mapSearch.locationPin {
                    Annotation((isCurrentLoc ? "Current Position" : "Destination"), coordinate:pin.coordinate) {
                        Button(action: {
                            locSelect = true
                        }) {
                            Image(systemName: (isCurrentLoc ? "location.circle.fill" : "mappin.circle.fill"))
                                .font(.title)
                                .foregroundStyle(isCurrentLoc ? .blue : .red)
                        }
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
            .onAppear {
                Task {
                    isCurrentLoc = true
                    mapSearch.getCurrentLocation()
                }
            }
            .mapStyle(.standard)
        }
        .onAppear {
            selectedCat = .randomQuery
            queryText = ""
            queryLat = ""
            queryLon = ""
        }
        .onChange(of: selectedCat) {
            if (selectedCat == .currentLoc) {
                isCurrentLoc = true
                mapSearch.getCurrentLocation()
            }
            queryText = ""
            queryLat = ""
            queryLon = ""
        }
        .alert("No result was found, or this is an extreme coordinate search. Please move the map around to find your located pin. If no pin was found, please try another search!", isPresented: $isAlert) {
            Button("Cancel", role: .cancel) {}
         }
    }
    
    
    
    
    //Extra func to chekc lat and lon values in the textfields
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
    
    func isValidCoor() -> Bool {
        if checkLat(lat: queryLat) && checkLon(lon: queryLon) && !queryLat.isEmpty && !queryLon.isEmpty {
            return true
        } else {
            return false
        }
    }

}




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

