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
    @State private var queryText = ""
    @State private var queryLat = ""
    @State private var queryLon = ""
    @State private var queryCity = ""
    @State private var locSelect: Bool = false
    @State private var selectedCat: SearchCategory = .randomQuery
    
    var body: some View {
        VStack {
            switch selectedCat {
                case .randomQuery:
                    HStack {
                        TextField("Enter location query", text: $queryText, onCommit: {
                            mapSearch.locationSearch(query: queryText)
                            mapSearch.isInitial = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            mapSearch.locationSearch(query: queryText)
                            mapSearch.isInitial = false
                        }) {
                            HStack {
                                Text("Search")
                                Image(systemName: "magnifyingglass.circle")
                            }
                            .padding(5)
                        }
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    SearchPickerView(selectedCat: $selectedCat)

                    Map(position: $mapSearch.camPos) {
                        if let pin = mapSearch.locationPin {
                            Annotation("Destination", coordinate:pin.coordinate) {
                                Button(action: {
                                    locSelect = true
                                }) {
                                    Image(systemName: (mapSearch.isInitial ? "location.circle.fill" : "mappin.circle.fill"))
                                        .font(.title)
                                        .foregroundStyle(mapSearch.isInitial ? .blue : .red)
                                }
                                .sheet(isPresented: $locSelect) {
                                    LocationView(lat: pin.coordinate.latitude, lon: pin.coordinate.longitude)
                                        .presentationDragIndicator(.visible)
                                }
                                
                            }
                        }
                    }
                    .mapStyle(.standard)
                
                
                case .cities:
                    // View for city search
                    
                    SearchPickerView(selectedCat: $selectedCat)
                    Text("WIP")
                
                case .coordination:
                    //View for coordinate search
                HStack {
                    TextField("Enter latitude", text: $queryLat)
                    TextField("Enter longitude", text: $queryLon)
                    //Button
                }
                    
                    SearchPickerView(selectedCat: $selectedCat)
                    Text("WIP")
                
                
                
            }
        }
        .onAppear(perform: mapSearch.getCurrentLocation)
    }
}




enum SearchCategory: String, CaseIterable, Identifiable {
    case randomQuery = "Query"
    case cities = "Cities"
    case coordination = "Coordinate"
    
    //Just giving a readable string as id for each case - conforming Identifiable
    var id: String { rawValue }
}



#Preview {
    MapView()
}

