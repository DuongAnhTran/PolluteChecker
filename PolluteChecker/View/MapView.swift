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
    @State private var locSelect: Bool = false
    @State private var selectedCat: SearchCategory = .randomQuery
    
    var body: some View {
        VStack {
            switch selectedCat {
                case .randomQuery:
                    TextField("Search for location", text: $queryText, onCommit: {
                        mapSearch.locationSearch(query: queryText)
                        mapSearch.isInitial = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
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
                    Text("WIP")
                
                
                
            }
        }
        .onAppear(perform: mapSearch.getCurrentLocation)
    }
}




enum SearchCategory: String, CaseIterable, Identifiable {
    case randomQuery = "Query"
    case cities = "Cities"
    
    //Just giving a readable string as id for each case - conforming Identifiable
    var id: String { rawValue }
}



#Preview {
    MapView()
}

